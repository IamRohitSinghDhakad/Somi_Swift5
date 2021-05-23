//
//  SideMenuViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit

class SideMenuViewController: UIViewController {

    //MARK:- IBoutlets
    @IBOutlet weak var subVwEnterMessage: UIView!
    @IBOutlet weak var vwContainEnterMsg: UIView!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var btnSaveSubVw: UIButton!
    @IBOutlet weak var vwBgBtnSave: UIView!
    
    var userType = ""
    
    //MARK:- App LyfCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.vwContainEnterMsg.layer.cornerRadius = 8
        self.vwContainEnterMsg.clipsToBounds = true
        self.subVwEnterMessage.isHidden = true
      
        self.userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
    }
    
    //MARK:- IBAction
    @IBAction func btnCancelSubVe(_ sender: Any) {
        self.view.endEditing(true)
        self.subVwEnterMessage.isHidden = true
    }
    @IBAction func btnSaveSubVw(_ sender: Any) {
        self.view.endEditing(true)
        
        if self.tfMessage.text != "" || self.tfMessage.text != " "{
            UserDefaults.standard.setValue(self.tfMessage.text, forKey: "emergency_message")
        }else{
            objAlert.showAlert(message: "Message can't empty", title: "Alert", controller: self)

        }
        self.subVwEnterMessage.isHidden = true
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
            self.vwBgBtnSave.backgroundColor = UIColor.init(named: "appBlueColor")
            
        }else{
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
            self.vwBgBtnSave.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }

    @IBAction func actionBtnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionBtnProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")as! ProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    @IBAction func actionsBtnProfile(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            self.navigationController?.popViewController(animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactListViewController")as! ContactListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController")as! HistoryViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationListViewController")as! NotificationListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
           // objAlert.showAlert(message: "Under Development", title: "Alert", controller: self)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController")as! AboutUsViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 5:
            let userID  = objAppShareData.UserDetail.strUserId
            if userID != ""{
                self.call_WSLogout(strUserID: userID)
            }
           
        case 6:
            self.subVwEnterMessage.isHidden = false
            self.tfMessage.becomeFirstResponder()
        case 7:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MembershipViewController")as! MembershipViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 8:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PhoneContactListViewController")as! PhoneContactListViewController
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        
    }
    
    
    
    //MARK:- Call WebService
    
    func call_WSLogout(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":strUserID,
                        ]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Logout, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                self.removeUserDefault()
                ObjAppdelegate.LoginNavigation()
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
           
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
    func removeUserDefault(){
        
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.userID)
        
    }
    
    
}
