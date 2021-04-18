//
//  ForgotPasswordViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var vwBtnBg: UIView!
    @IBOutlet weak var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfEmail.delegate = self
        
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
    
    @IBAction func actionBtnSubmit(_ sender: Any) {
        self.validateForSignUp()
    }
    @IBAction func actionBtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- All Validations
    func validateForSignUp(){
     
        self.tfEmail.text = self.tfEmail.text!.trim()
     
        if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else{
            self.call_WsForgotPassword()
        }
    }

}

extension ForgotPasswordViewController : UITextFieldDelegate{
    // TextField delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.tfEmail{
            self.tfEmail.resignFirstResponder()
        }
        return true
    }
}

//MARK:- Call Webservice
extension ForgotPasswordViewController{
    func call_WsForgotPassword(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["email":self.tfEmail.text!]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_ForgotPassword, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                objAlert.showAlertCallBack(alertLeftBtn: "OK", alertRightBtn: "", title: "Success", message: message ?? "Password sent to your registered email ID", controller: self) {
                    self.navigationController?.popViewController(animated: true)
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
}
