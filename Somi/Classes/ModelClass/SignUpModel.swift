//
//  SignUpModel.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 25/03/21.
//

import UIKit

class SignUpModel: NSObject {

    var strName           : String = ""
    var strEmail          : String = ""
    var strPassword       : String = ""
    var strConfirmPassword : String = ""
    var strPhoneNo        : String = ""
    var strDialCode        : String = ""
    var strCountryCode    : String = ""
    var strDeviceToken    : String = ""
}

class userDetailModel: NSObject {
    var straAuthToken          : String = ""
    var strCountyCode          : String = ""
    var strCreateAt            : String = ""
    var strDeviceId            : String = ""
    var strDeviceTimeZone        : String = ""
    var strDeviceType          : String = ""
    var strDeviceToken           : String = ""
    
    var strEmail                : String = ""
    var strName                  : String = ""
    var strPhoneDialCode        : String = ""
    var strPhoneNumber          : String = ""
    var strProfilePicture     : String = ""
    var strUserId               : String = ""
    var strUserType         : String = ""
    var strEmergencyNumber     :String = ""
    var strAllergy     :String = ""
    var strBloodGroup    :String = ""

    var strGender :String = ""
    
    init(dict : [String:Any]) {
        
        if let userID = dict["user_id"] as? String{
            self.strUserId = userID
            UserDefaults.standard.setValue(self.strUserId, forKey: UserDefaults.Keys.userID)
        }else  if let userID = dict["user_id"] as? Int{
            self.strUserId = "\(userID)"
            UserDefaults.standard.setValue(self.strUserId, forKey: UserDefaults.Keys.userID)
        }
        
        if let emergencyNumber = dict["emergency_number"] as? String{
            self.strEmergencyNumber = emergencyNumber
        }else  if let emergencyNumber = dict["emergency_number"] as? Int{
            self.strEmergencyNumber = "\(emergencyNumber)"
        }
        
        if let userType = dict["type"] as? String{
           self.strUserType = userType
        }
        
        if let mobile = dict["mobile"] as? String{
           self.strPhoneNumber = mobile
        }
        
        if let gender = dict["sex"] as? String{
        UserDefaults.standard.setValue(gender, forKey: UserDefaults.Keys.userType)
           self.strGender = gender
        }
        
//        if let username = dict["username"] as? String{
//            self.strUserName = username
//        }
        

        if let bloodGroup = dict["blood_group"] as? String{
            self.strBloodGroup = bloodGroup
        }
        
        if let allergy = dict["allergy"] as? String{
            self.strAllergy = allergy
        }
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let email = dict["email"] as? String{
            self.strEmail = email
        }
        
        if let country_code = dict["country_code"] as? String{
            self.strCountyCode = country_code
        }
        
        if let profile_picture = dict["user_image"] as? String{
            self.strProfilePicture = profile_picture
        }
        
        if let phone_dial_code = dict["phone_dial_code"] as? String{
            self.strPhoneDialCode = phone_dial_code
        }
        
        
        if let created_at = dict["created_at"] as? String{
            self.strCreateAt = created_at
        }
        if let device_id = dict["device_id"] as? String{
            self.strDeviceId = device_id
        }
        
        if let device_timezone = dict["device_timezone"] as? String{
            self.strDeviceTimeZone = device_timezone
        }
        
        if let device_token = dict["device_token"] as? String{
            self.strDeviceToken = device_token
        }
        
        if let device_type = dict["device_type"] as? String{
            self.strDeviceType = device_type
        }
        
//        if let auth_token = dict["auth_token"] as? String{
//            self.straAuthToken = auth_token
//            UserDefaults.standard.setValue(auth_token, forKey: objAppShareData.UserDetail.straAuthToken)
//        }
               
        
    }
}
