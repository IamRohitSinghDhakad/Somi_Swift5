//
//  ViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 22/03/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var vwBynBg: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfEmail.delegate = self
        self.tfPassword.delegate = self
        
        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        // Do any additional setup after loading the view.
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwBynBg.backgroundColor = UIColor.init(named: "appBlueColor")
            
        }else{
            self.vwBynBg.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }


    @IBAction func actionBtnLogin(_ sender: Any) {
       // self.validateForSignUp()
        self.call_WsLogin()
    }
    @IBAction func actionBtnForgotPassword(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController")as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionbtnSignUp(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- All Validations
    func validateForSignUp(){
     
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfPassword.text = self.tfPassword.text!.trim()
        if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfPassword.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPassword, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else{
            self.call_WsLogin()
        }
    }
    
}

extension ViewController : UITextFieldDelegate{
    // TextField delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfEmail{
            self.tfPassword.becomeFirstResponder()
            self.tfEmail.resignFirstResponder()
        }
        else if textField == self.tfPassword{
            self.tfPassword.resignFirstResponder()
        }
        return true
    }
}

//MARK:- Call Webservice
extension ViewController{
    func call_WsLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["username":self.tfEmail.text!,
                         "password":self.tfPassword.text!,
                         "type":"user"]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_Login, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                let user_details  = response["result"] as? [String:Any]

                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                
                ObjAppdelegate.HomeNavigation()
                
                
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

extension UIViewController{
    func show() {
        let window = UIApplication.shared.delegate?.window
        let visibleVC = window??.visibleViewController
        visibleVC?.present(self, animated: true, completion: nil)
    }
}
