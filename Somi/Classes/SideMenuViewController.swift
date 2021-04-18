//
//  SideMenuViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit

class SideMenuViewController: UIViewController {

    @IBOutlet weak var subVwEnterMessage: UIView!
    @IBOutlet weak var vwContainEnterMsg: UIView!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var btnSaveSubVw: UIButton!
    @IBOutlet weak var vwBgBtnSave: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.vwContainEnterMsg.layer.cornerRadius = 8
        self.vwContainEnterMsg.clipsToBounds = true
        self.subVwEnterMessage.isHidden = true
        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        
        // Do any additional setup after loading the view.
    }
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
            print("Home")
            self.navigationController?.popViewController(animated: true)
        case 1:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactListViewController")as! ContactListViewController
            self.navigationController?.pushViewController(vc, animated: true)
            print("My Contact")
        case 2:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController")as! HistoryViewController
            self.navigationController?.pushViewController(vc, animated: true)
            print("History")
        case 3:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController")as! NotificationViewController
            self.navigationController?.pushViewController(vc, animated: true)
            print("Notification")
        case 4:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddContactsViewController")as! AddContactsViewController
            self.navigationController?.pushViewController(vc, animated: true)
            print("About Us")
        case 5:
            self.removeUserDefault()
            ObjAppdelegate.LoginNavigation()
        case 6:
            self.subVwEnterMessage.isHidden = false
            self.tfMessage.becomeFirstResponder()
        default:
            break
        }
        
    }
    
    func removeUserDefault(){
        
        UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.userID)
        
    }
    
    
}
