//
//  ContactListViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit
import ContactsUI

class ContactListViewController: UIViewController {

    //MARK:- IBoutlets
    @IBOutlet weak var tblContactList: UITableView!
    @IBOutlet weak var vwHeaderBg: UIView!
    @IBOutlet var vwSomiContact: UIView!
    @IBOutlet var vwTrustContact: UIView!
    @IBOutlet var lblSomiContact: UILabel!
    @IBOutlet var lblTrustContact: UILabel!
    
    var userType = ""
    var arrGetMyContacts = [GetContactsModel]()
    var arrGetMyTrustedContacts = [GetContactsModel]()
    var isTrustedContactShow = Bool()
    
    //MARK:- App Lyf Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblContactList.delegate = self
        self.tblContactList.dataSource = self
        
        self.lblSomiContact.textColor = UIColor.white
        self.vwSomiContact.layer.cornerRadius = 5
        self.lblTrustContact.textColor = UIColor.black
        self.vwTrustContact.layer.backgroundColor = UIColor.white.cgColor
        self.vwTrustContact.layer.borderWidth = 1.0
        self.vwTrustContact.layer.cornerRadius = 5
        
//        self.userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
//        self.setStyling(strUserType: userType)
        
        self.call_WsGetContactList(strUserID: objAppShareData.UserDetail.strUserId)
        self.call_WsGetContactListTrusted(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        self.userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
            self.vwSomiContact.layer.backgroundColor = UIColor.init(named: "appBlueColor")?.cgColor
            self.vwTrustContact.layer.borderColor = UIColor.init(named: "appBlueColor")?.cgColor
            
        }else{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
            self.vwSomiContact.layer.backgroundColor = UIColor.init(named: "appPinkColor")?.cgColor
            self.vwTrustContact.layer.borderColor = UIColor.init(named: "appPinkColor")?.cgColor
        }
    }

    @IBAction func actionBtnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func btnSomiContact(_ sender: Any) {
        self.lblSomiContact.textColor = UIColor.white
        self.vwSomiContact.layer.backgroundColor = UIColor.init(named: "appBlueColor")?.cgColor
        
        self.lblTrustContact.textColor = UIColor.black
        self.vwTrustContact.layer.backgroundColor = UIColor.white.cgColor
        self.vwTrustContact.layer.borderWidth = 1.0
        self.vwTrustContact.layer.borderColor = UIColor.init(named: "appBlueColor")?.cgColor
        self.vwTrustContact.layer.cornerRadius = 5
        
        if self.userType == "Male"{
            self.vwSomiContact.layer.backgroundColor = UIColor.init(named: "appBlueColor")?.cgColor
            self.vwTrustContact.layer.borderColor = UIColor.init(named: "appBlueColor")?.cgColor
        }else{
            self.vwSomiContact.layer.backgroundColor = UIColor.init(named: "appPinkColor")?.cgColor
            self.vwTrustContact.layer.borderColor = UIColor.init(named: "appPinkColor")?.cgColor
        }
        
        self.isTrustedContactShow = false
        self.tblContactList.reloadData()
    }
    
    @IBAction func btnTrustContact(_ sender: Any) {
        
        self.lblTrustContact.textColor = UIColor.white
        if self.userType == "Male"{
            self.vwTrustContact.layer.backgroundColor = UIColor.init(named: "appBlueColor")?.cgColor
            self.vwSomiContact.layer.borderColor = UIColor.init(named: "appBlueColor")?.cgColor
        }else{
            self.vwTrustContact.layer.backgroundColor = UIColor.init(named: "appPinkColor")?.cgColor
            self.vwSomiContact.layer.borderColor = UIColor.init(named: "appPinkColor")?.cgColor
        }
        
        
        self.lblSomiContact.textColor = UIColor.black
        self.vwSomiContact.layer.backgroundColor = UIColor.white.cgColor
        self.vwSomiContact.layer.borderWidth = 1.0
        
        self.vwSomiContact.layer.cornerRadius = 5
        
        self.isTrustedContactShow = true
        self.tblContactList.reloadData()
    }
    
}


//MARK:- UITableViewDelgates and DataSource
extension ContactListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isTrustedContactShow{
            return self.arrGetMyTrustedContacts.count
        }else{
            return self.arrGetMyContacts.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell")as? ContactsTableViewCell{
            
            var obj = GetContactsModel(dict: [:])
            
            if self.isTrustedContactShow{
                obj = self.arrGetMyTrustedContacts[indexPath.row]
            }else{
                obj = self.arrGetMyContacts[indexPath.row]
            }
            
             
            
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
            

            if self.isTrustedContactShow{
                cell.vwSave.isHidden = true
            }else{
                cell.vwSave.isHidden = false
            }
            
            cell.btnAdd.tag = indexPath.row
            cell.btnAdd.addTarget(self, action: #selector(btnActionAdd(sender:)), for: .touchUpInside)

            cell.btnSave.tag = indexPath.row
            cell.btnSave.addTarget(self, action: #selector(btnActionSave(sender:)), for: .touchUpInside)

            
            let profilePic = obj.strUserImage
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }else{
                cell.imgVwUser.image = #imageLiteral(resourceName: "logo")
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    @objc func btnActionAdd(sender: UIButton){
        let buttonTag = sender.tag
        if self.isTrustedContactShow{
            let obj = self.arrGetMyTrustedContacts[buttonTag]
            self.call_WsGetAddContactInList(strUserID: obj.strUserContactID, strName: obj.strName, strPhoneNumber: obj.strMobile, strIndexPath: buttonTag)
        }else{
            let obj = self.arrGetMyContacts[buttonTag]
            self.call_WSDeleteUserContact(strContactID: obj.strUserIDForDelete, Indexpath: buttonTag)
        }
    }
    
    @objc func btnActionSave(sender: UIButton){
        let buttonTag = sender.tag
        let obj = self.arrGetMyContacts[buttonTag]
        
        let store = CNContactStore()
        let contact = CNMutableContact()
        
        // Name
        contact.givenName = obj.strName
        
        // Phone
        contact.phoneNumbers.append(CNLabeledValue(
                                        label: "mobile", value: CNPhoneNumber(stringValue: obj.strMobile)))
        objAlert.showAlertCallBack(alertLeftBtn: "Cancel", alertRightBtn: "OK", title: "Alert", message: "Are you sure you want to save number on your Contact list", controller: self) {
            
            // Save
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier: nil)
            try? store.execute(saveRequest)
            
            objAlert.showAlert(message: "Saved Succesfully!", controller: self)
            
        }
       
        
    }
    
    
}

//MARK:- Call Webservice Contact List
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
                    if self.arrGetMyContacts.count == 0{
                        self.tblContactList.displayBackgroundText(text: "No Record Found")
                    }else{
                        self.tblContactList.displayBackgroundText(text: "")
                    }
                    self.tblContactList.reloadData()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                self.tblContactList.displayBackgroundText(text: "No Contact Found")
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
    
    //MARK:- Call Webservice Show Trusted Contact List
    func call_WsGetContactListTrusted(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetMyContact, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for dictData in arrData{
                        let obj = GetContactsModel.init(dict: dictData)
                        self.arrGetMyTrustedContacts.append(obj)
                    }

                    if self.arrGetMyTrustedContacts.count == 0{
                        self.tblContactList.displayBackgroundText(text: "No Record Found")
                    }else{
                        self.tblContactList.displayBackgroundText(text: "")
                    }
                    
                    self.tblContactList.reloadData()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                if self.arrGetMyTrustedContacts.count == 0{
                    self.tblContactList.displayBackgroundText(text: "No Record Found")
                }else{
                    self.tblContactList.displayBackgroundText(text: "")
                }
                // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    //MARK:- Call Webservice Delete Contact
    func call_WSDeleteUserContact(strContactID:String, Indexpath: Int){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
        
       // let dicrParam = ["user_contact_id":strContactID]as [String:Any]
        let dicrParam = ["contact_id":strContactID,
                         "user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_AddUserContact, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                if self.isTrustedContactShow{
                    self.arrGetMyTrustedContacts.remove(at: Indexpath)
                }else{
                    self.arrGetMyContacts.remove(at: Indexpath)
                }
               
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
    
    //MARK:- Delete Trusted Contact
    func call_WsGetAddContactInList(strUserID:String,strName:String,strPhoneNumber:String, strIndexPath:Int){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":strUserID,
                         "name":strName,
                         "mobile":strPhoneNumber]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_AddMyContact, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
    
                if let dictData  = response["result"] as? [String:Any]{
                    print(dictData)
                  
                }else{
                    self.arrGetMyTrustedContacts.remove(at: strIndexPath)
                    self.tblContactList.reloadData()
                   // objAlert.showAlert(message: message ?? "" , title: "Alert", controller: self)
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "" , title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
