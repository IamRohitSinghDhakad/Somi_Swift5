//
//  UserDefaultExtension.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 25/03/21.
//

import Foundation
import Foundation
import UIKit

var deviceToken: String? {
    get {
        return UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.deviceToken) as? String ?? "abc"
    }
}



extension UserDefaults{
    enum KeysDefault {
        //user Info
        static let userInfo = "userInfo"
        static let strVenderId = "udid"
        static let deviceToken = "device_token"
        static let contentURLs = "content"
        static let kAuthToken = "authToken"
        static  let kUserId = "userId"
        static  let kUserName = "userName"
    }
    
}

