//
//  GetContactsModel.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 28/03/21.
//

import UIKit

class GetContactsModel: NSObject {
    
    
   
    
    var strUserContactID:String = ""
    var strUserIDForDelete:String = ""
    var strUserImage:String = ""
    var strEmail:String = ""
    var strMobile:String = ""
    var strName:String = ""
    var isAdded = Bool()
    var isContactAdded = Int()
    
    

    init(dict : [String:Any]) {
        
        if let mobile = dict["mobile"] as? String{
            self.strMobile = mobile
        }
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let catImage = dict["user_image"] as? String{
            self.strUserImage = catImage
        }
        
        if let userID = dict["user_id"] as? String{
            self.strUserContactID = userID
        }else  if let userID = dict["user_id"] as? Int{
            self.strUserContactID = "\(userID)"
        }
        
        if let userID = dict["user_contact_id"] as? String{
            self.strUserIDForDelete = userID
        }else  if let userID = dict["user_contact_id"] as? Int{
            self.strUserIDForDelete = "\(userID)"
        }
        
        
        
        if let isContactID = dict["contact_added"] as? Int{
            self.isContactAdded = isContactID
        }
    }
    

}
