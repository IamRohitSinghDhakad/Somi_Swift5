//
//  AddContactsViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit

class AddContactsViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var tblAddContacts: UITableView!
    @IBOutlet weak var vwBtnBg: UIView!
    
    var arrGetContacts = [GetContactsModel]()
    
    var userTypeCheck = ""
    var userID = ""
    
    //MARK:- App Lyf Cycyle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblAddContacts.delegate = self
        self.tblAddContacts.dataSource = self
        
//        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
//        self.setStyling(strUserType: userType)
        
        userID  = objAppShareData.UserDetail.strUserId
       if userID != ""{
           self.call_WsGetContactList(strUserID: userID)
       }
        
        userTypeCheck = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appBlueColor")
            
        }else{
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }

    @IBAction func actionBtnNext(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")as! HomeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

//MARK:- UITableView Delgates and DataSorce
extension AddContactsViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGetContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell")as? ContactsTableViewCell{
            
            
            let obj = self.arrGetContacts[indexPath.row]
           
            cell.lblUserName.text = obj.strName
            cell.lblPhoneNumber.text = obj.strMobile
            
            if obj.isContactAdded > 0{
                cell.btnAdd.setTitle("Remove", for: .normal)
                cell.btnAdd.setTitleColor(.white, for: .normal)
                if userTypeCheck == "Male"{
                    cell.vwAddRemove.backgroundColor = UIColor.init(named: "appBlueColor")
                }else{
                    cell.vwAddRemove.backgroundColor = UIColor.init(named: "appPinkColor")
                }
                cell.vwAddRemove.layer.cornerRadius = 6
                cell.vwAddRemove.layer.borderWidth = 0.0
            }else{
                cell.btnAdd.setTitle("Add", for: .normal)
                cell.vwAddRemove.layer.cornerRadius = 6
               
                if userTypeCheck == "Male"{
                    cell.vwAddRemove.backgroundColor = .clear
                    cell.vwAddRemove.layer.borderColor = UIColor.init(named: "appBlueColor")?.cgColor
                }else{
                    cell.vwAddRemove.backgroundColor = .clear
                    cell.vwAddRemove.layer.borderColor = UIColor.init(named: "appPinkColor")?.cgColor
                }
                // border
                cell.vwAddRemove.layer.borderWidth = 1.0
                cell.btnAdd.setTitleColor(.black, for: .normal)
            }
            
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
        //self.navigationController?.popViewController(animated: true)
        let obj = self.arrGetContacts[indexPath.row]
        
        if obj.isAdded == true{
            self.call_WSAddContacts(strUserID: self.userID, strContactID: obj.strUserContactID, Indexpath: indexPath.row)
           // self.call_WSDeleteUserContact(strUserID: self.userID, strContactID: obj.strUserContactID, Indexpath: indexPath.row)
        }else{
            self.call_WSAddContacts(strUserID: self.userID, strContactID: obj.strUserContactID, Indexpath: indexPath.row)
        }
    }
    
}


//MARK:- Call Webservice Contact List
extension AddContactsViewController{
    func call_WsGetContactList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":strUserID]as [String:Any]
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetAllUsers, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for dictData in arrData{
                     
                        let obj = GetContactsModel.init(dict: dictData)
                        self.arrGetContacts.append(obj)
                        
                    }
                    self.tblAddContacts.reloadData()
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
    
    
    func call_WSAddContacts(strUserID:String, strContactID:String, Indexpath: Int){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":strUserID,
                         "contact_id":strContactID]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_AddUserContact, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                self.arrGetContacts.removeAll()
                self.call_WsGetContactList(strUserID: self.userID)
                
                
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


extension UIImageView {

    func makeCircleImage() {
        self.layer.borderWidth = 0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
