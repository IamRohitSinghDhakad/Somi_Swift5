//
//  NotificationListModel.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 02/05/21.
//

import UIKit

class NotificationListModel: NSObject {
    
    
    var strName = ""
    var strRequestID = ""
    var strTimeAgo = ""
    var strNotificationTitle = ""
    var userImage = ""
    
    init(dict : [String:Any]) {
        
        if let reqID = dict["user_request_id"] as? String{
            self.strRequestID = reqID
        }else if let reqID = dict["user_request_id"] as? Int{
            self.strRequestID = "\(reqID)"
        }
        
        if let name = dict["name"] as? String{
            self.strName = name
        }
        
        if let img = dict["user_image"] as? String{
            self.userImage = img
        }
        
        if let timeAgo = dict["time_ago"] as? String{
            self.strTimeAgo = timeAgo
        }
        
        if let notificationTitle = dict["notification_title"] as? String{
            self.strNotificationTitle = notificationTitle
        }
        
        
    }

}
