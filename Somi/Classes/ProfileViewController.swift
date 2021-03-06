//
//  ProfileViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var vwHeaderBg: UIView!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblBloodGroup: UILabel!
    @IBOutlet weak var lblAllergy: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet var imgVwMale: UIImageView!
    @IBOutlet var imgVwFemale: UIImageView!
    @IBOutlet var lblEmergencyNumber: UILabel!
    @IBOutlet var imgVwEditProfile: UIImageView!
    
    var urlImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let userID = objAppShareData.UserDetail.strUserId
       if userID != ""{
           self.call_GetProfile(strUserID: userID)
       }
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
            self.imgVwEditProfile.image = #imageLiteral(resourceName: "edit_profile_icon")
        }else{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
            self.imgVwEditProfile.image = #imageLiteral(resourceName: "edit_pink")
        }
    }
    @IBAction func actionBtnBackOnheader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func actionBtnEditProfile(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController")as! EditProfileViewController
        
        vc.dictUserData["email"] = self.lblEmail.text!
        vc.dictUserData["mobile"] = self.lblMobile.text!
        vc.dictUserData["blood"] = self.lblBloodGroup.text!
        vc.dictUserData["allergy"] = self.lblAllergy.text!
        vc.dictUserData["address"] = self.lblAddress.text!
        vc.dictUserData["user_image"] = self.urlImage
        vc.dictUserData["emergency_number"] = self.lblEmergencyNumber.text!

        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension ProfileViewController{
    func call_GetProfile(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
       
        
        let dicrParam = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
           
            if status == MessageConstant.k_StatusCode{
                
                if  let user_details  = response["result"] as? [String:Any] {
                    
                    if let mobileNumber = user_details["mobile"]as? String{
                        self.lblMobile.text = mobileNumber
                    }
                    
                    if let email = user_details["email"]as? String{
                        self.lblEmail.text = email
                    }
                    
                    if let address = user_details["address"]as? String{
                        self.lblAddress.text = address
                    }
                    
                    if let bloodGroup = user_details["blood_group"]as? String{
                        self.lblBloodGroup.text = bloodGroup
                    }else{
                        self.lblBloodGroup.text = "O+"
                    }
                    
                    if let allergy = user_details["allergy"]as? String{
                        self.lblAllergy.text = allergy
                    }else{
                        self.lblAllergy.text = "N/A"
                    }
                    
                    if let profilePic = user_details["user_image"] as? String{
                        self.urlImage = profilePic
                        if profilePic != "" {
                            let url = URL(string: profilePic)
                            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img"))
                        }
                    }
                    
                    if let emergency_number = user_details["emergency_number"]as? String{
                        self.lblEmergencyNumber.text = emergency_number
                    }else  if let emergency_number = user_details["emergency_number"]as? Int{
                        self.lblEmergencyNumber.text = "\(emergency_number)"
                    }
                    
                    
                    if let address = user_details["address"]as? String{
                        self.lblAddress.text = address
                    }else{
                        self.lblAddress.text = "N/A"
                    }
                    
                    if let gender = user_details["sex"]as? String{
                        if gender == "Male"{
                            self.imgVwMale.image = #imageLiteral(resourceName: "blue")
                            self.imgVwFemale.image = #imageLiteral(resourceName: "pink")
                            self.imgVwEditProfile.image = #imageLiteral(resourceName: "edit_profile_icon")
                            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
                            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
                        }else{
                            self.imgVwFemale.image = #imageLiteral(resourceName: "check")
                            self.imgVwMale.image = #imageLiteral(resourceName: "uncheck")
                            self.imgVwEditProfile.image = #imageLiteral(resourceName: "edit_pink")
                            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
                            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
                        }
                    }
                    
                }
                
              //  self.lblEmail.text =
                
                
            }else{
                objAlert.showAlert(message: message!, title: "Alert", controller: self)
            }
            
            
        } failure: { (Error) in
            print(Error)
            
            objWebServiceManager.hideIndicator()
        }

    
   }

}



