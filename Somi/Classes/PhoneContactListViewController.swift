//
//  PhoneContactListViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/05/21.
//

import UIKit
import ContactsUI

enum ContactsFilter {
    case none
    case mail
    case message
}


class PhoneContactListViewController: UIViewController {
    
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet var tblVw: UITableView!
    @IBOutlet var vwBgHeader: UIView!
    @IBOutlet var vwSearchBarBorder: UIView!
    
    var userType = ""
    
    var filter: ContactsFilter = .none
    var arrPhoneContacts = [PhoneContactModal]() // array of PhoneContact(It is model find it below)
    var arrPhoneContactsFiltered = [PhoneContactModal]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        self.tfSearch.delegate = self
        
        vwSearchBarBorder.layer.masksToBounds = false
        vwSearchBarBorder.cornerRadius = 5
        vwSearchBarBorder.layer.borderWidth = 1
        vwSearchBarBorder.layer.borderColor = UIColor.lightGray.cgColor
        
        
        self.tfSearch.addTarget(self, action: #selector(searchContactAsPerText(_ :)), for: .editingChanged)
        
        self.call_WsGetContactList(strUserID: objAppShareData.UserDetail.strUserId)
        
        RequestPermission.requestAccess(completionHandler: { [weak self](isGranted) in
            guard self != nil else{return}
            if isGranted{
                self!.loadContacts(filter: self!.filter)
                // self?.call_wsGetAllUser()
            }else{
                
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
    }
    
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwBgHeader.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
        }else{
            self.vwBgHeader.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }
    
    @IBAction func btnSideZMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK:- Searching
extension PhoneContactListViewController:UITextFieldDelegate{
    
    @objc func searchContactAsPerText(_ textfield:UITextField) {
        self.arrPhoneContactsFiltered.removeAll()
        if textfield.text?.count != 0 {
            for dicData in self.arrPhoneContacts {
                let isMachingWorker : NSString = (dicData.name ?? "") as NSString
                let range = isMachingWorker.lowercased.range(of: textfield.text!, options: NSString.CompareOptions.caseInsensitive, range: nil,   locale: nil)
                if range != nil {
                    arrPhoneContactsFiltered.append(dicData)
                }
            }
        } else {
            self.arrPhoneContactsFiltered = self.arrPhoneContacts
        }
        if self.arrPhoneContactsFiltered.count == 0{
            self.tblVw.displayBackgroundText(text: "No Record Found")
        }else{
            self.tblVw.displayBackgroundText(text: "")
        }
       // self.arrPhoneContactsFiltered = self.arrPhoneContactsFiltered.sorted(by: { $0.sort > $1.sort})
        self.tblVw.reloadData()
    }
    
    
}

//MARK:- UITAbleVie Datasaource and Delagete
extension PhoneContactListViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPhoneContactsFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell")as! ContactsTableViewCell
        
        let obj = self.arrPhoneContactsFiltered[indexPath.row]
        
        cell.lblUserName.text = obj.name
        
        if obj.phoneNumber.count > 0{
            cell.lblPhoneNumber.text = obj.phoneNumber[0]
        }else{
            cell.lblPhoneNumber.text = "N/A"
        }
        
        //Set Contact Image
        let imageData = obj.avatarData
        if imageData != nil{
            let avtarImage : UIImage = UIImage(data: imageData!)!
            cell.imgVwUser.image = avtarImage
        }else{
            cell.imgVwUser.image = #imageLiteral(resourceName: "logo")
        }
        
        cell.btnAdd.setTitleColor(UIColor.white, for: .normal)
        
        if obj.isSelected == true{
            
            cell.btnAdd.setTitle("Remove", for: .normal)
            if self.userType == "Male"{
                cell.vwAddRemove.backgroundColor = UIColor.init(named: "appBlueColor")
            }else{
                cell.vwAddRemove.backgroundColor = UIColor.init(named: "appPinkColor")
            }
            
        }else{
            cell.btnAdd.setTitle("Add", for: .normal)
            
            if self.userType == "Male"{
                cell.vwAddRemove.backgroundColor = UIColor.init(named: "appBlueColor")
                
            }else{
                cell.vwAddRemove.backgroundColor = UIColor.init(named: "appPinkColor")
            }
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrPhoneContactsFiltered[indexPath.row]
        
        if obj.name != "" && obj.phoneNumber.count > 0{
            self.call_WsGetAddContactInList(strUserID: objAppShareData.UserDetail.strUserId, strName: obj.name!, strPhoneNumber: obj.phoneNumber[0], strIndexPath: indexPath.row)
        }else{
            objAlert.showAlert(message: "Details not Found", title: "Alert", controller: self)
        }
    }
    
    
}


//MARK:- Fetching Phonbook
extension PhoneContactListViewController{
    fileprivate func loadContacts(filter: ContactsFilter) {
        arrPhoneContacts.removeAll()
        var allContacts = [PhoneContactModal]()
        for contact in PhoneContacts.getContacts(filter: filter) {
            allContacts.append(PhoneContactModal(contact: contact))
        }
        var filterdArray = [PhoneContactModal]()
        if self.filter == .mail {
            filterdArray = allContacts.filter({ $0.email.count > 0 }) // getting all email
        } else if self.filter == .message {
            filterdArray = allContacts.filter({ $0.phoneNumber.count > 0 })
        } else {
            filterdArray = allContacts
        }
        arrPhoneContacts.append(contentsOf: filterdArray)
        self.arrPhoneContactsFiltered = self.arrPhoneContacts
        DispatchQueue.main.async {
            self.tblVw.reloadData()
        }
    }
}


extension PhoneContactListViewController{
    
    // https://ambitious.in.net/Arun/Somi/index.php/api/get_my_contact?user_id=1
    func call_WsGetContactList(strUserID:String){
        
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
                    
                    print(arrData)
                    
                    for dictData in arrData{
                        
                        let objUserList = PhoneContactModal.init(dictChooseContact: dictData)
                        let serverSideNumber = objUserList.strPhoneNumber
                        print(serverSideNumber)
                        //Whithout Using Loop
                        for i in self.arrPhoneContacts{
                            let localPhoneNumber = i.phoneNumber
                            
                            if localPhoneNumber.contains(where: {
                                $0.range(of: serverSideNumber, options: .caseInsensitive) != nil
                            }){
                                i.isSelected = true
                            }else{
                                
                            }
                        }
                        
                    }
                    if self.arrPhoneContacts.count == 0{
                        self.tblVw.displayBackgroundText(text: "No Record Found")
                    }else{
                        self.tblVw.displayBackgroundText(text: "")
                    }
                    self.tblVw.reloadData()
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
                
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    
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
                
                print(response)
                
                
                if let dictData  = response["result"] as? [String:Any]{
                    print(dictData)
                    self.arrPhoneContactsFiltered[strIndexPath].isSelected = true
                    self.tblVw.reloadData()
                    
                }else{
                    
                    if response["is_deleted"] as? Int == 1{
                        self.arrPhoneContactsFiltered[strIndexPath].isSelected = false
                        self.tblVw.reloadData()
                    }else{
                        objAlert.showAlert(message: "Something went Wrong", title: "Alert", controller: self)
                    }
                }
                
            }else{
                objWebServiceManager.hideIndicator()
                if let msg = response["result"]as? String{
                    objAlert.showAlert(message: msg , title: "Alert", controller: self)
                }else{
                    
                }
                 
            }
            
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
}
