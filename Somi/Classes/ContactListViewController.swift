//
//  ContactListViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit

class ContactListViewController: UIViewController {

    @IBOutlet weak var tblContactList: UITableView!
    @IBOutlet weak var vwHeaderBg: UIView!
    
    var userType = ""
    var arrGetMyContacts = [GetContactsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblContactList.delegate = self
        self.tblContactList.dataSource = self
        
        self.userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        
        self.call_WsGetContactList(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
        }else{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }

    @IBAction func actionBtnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  

}


extension ContactListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGetMyContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell")as? ContactsTableViewCell{
            
            let obj = self.arrGetMyContacts[indexPath.row]
            
            cell.btnAdd.setTitle("Remove", for: .normal)
            cell.btnAdd.setTitleColor(.white, for: .normal)
            if self.userType == "Male"{
                cell.vwAddRemove.backgroundColor = UIColor.init(named: "appBlueColor")
            }else{
                cell.vwAddRemove.backgroundColor = UIColor.init(named: "appPinkColor")
            }
            cell.vwAddRemove.layer.cornerRadius = 6
            cell.vwAddRemove.layer.borderWidth = 0.0
            
            cell.lblUserName.text = obj.strName
            cell.lblPhoneNumber.text = obj.strMobile
            
            let profilePic = obj.strUserImage
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrGetMyContacts[indexPath.row]
        self.call_WSDeleteUserContact(strContactID: obj.strUserIDForDelete, Indexpath: indexPath.row)
        
    }
    
}


extension ContactListViewController{
    
    func call_WsGetContactList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetUserContacts, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for dictData in arrData{
                     
                        let obj = GetContactsModel.init(dict: dictData)
                        self.arrGetMyContacts.append(obj)
                        
                    }
                    self.tblContactList.reloadData()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
    
    func call_WSDeleteUserContact(strContactID:String, Indexpath: Int){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_contact_id":strContactID]as [String:Any]
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_RemoveUserContact, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                self.arrGetMyContacts.remove(at: Indexpath)
                self.tblContactList.reloadData()
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
           
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
}
