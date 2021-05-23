//
//  PhoneContactModal.swift
//  Bang
//
//  Created by RohitSingh-MacMINI on 20/05/19.
//  Copyright © 2019 mindiii. All rights reserved.
//

import UIKit
import ContactsUI

class PhoneContactModal: NSObject {
    
    var name: String?
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var isSelected: Bool = false
    var isInvited = false
    
    //-----------Variables For ServerSide-------------------//
    var strUserID = ""
    var strCountryCode = ""
    var strPhoneNumber = ""
    var strGender = ""
    var isContactMatched = false
    var sort = 0
    var checkContactSelectedOrNot = -1
    //-----------_-_-_-_-_-_-_-_-_-_-_-_-_-------------------//
    
    init(contact: CNContact) {
        name        = contact.givenName + " " + contact.familyName
        avatarData  = contact.thumbnailImageData
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue.alphanumeric)
        }
        for mail in contact.emailAddresses {
            email.append(mail.value as String)
        }
    }
    
    override init() {
        super.init()
        
    }
    
    //----------- For ServerSide---------------//
    init(dictChooseContact:[String:Any]) {
        super.init()
        
        if let userId = dictChooseContact["userId"]as? Int{
            strUserID = "\(userId)"
        }
        
        if let countryCode = dictChooseContact["country_code"] as? String{
            strCountryCode = countryCode
        }
        
        if let phoneNumber = dictChooseContact["mobile"] as? String{
            strPhoneNumber = phoneNumber
        }else  if let phoneNumber = dictChooseContact["mobile"] as? Int{
            strPhoneNumber = "\(phoneNumber)"
        }
        
        if let gender = dictChooseContact["gender"]as? String{
            strGender = gender
        }
        
    }
   //-----------_-_-_-_-_-_-_-_-_-_-_-_-_-------------------//
}


extension String {
    var alphanumeric: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
}
