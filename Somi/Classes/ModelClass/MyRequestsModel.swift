//
//  MyRequestsModel.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 28/03/21.
//

import UIKit

class MyRequestsModel: NSObject {

    var strUserAddress:String = ""
    var strCategoryName:String = ""
    var strDateTime:String = ""
    var strName:String = ""
    var isAdded = Bool()
    var isContactAdded = Int()
    

    init(dict : [String:Any]) {
        
        if let address = dict["address"] as? String{
            self.strUserAddress = address
        }
        
        if let category_name = dict["category_name"] as? String{
            self.strCategoryName = category_name
        }
        
        if let datetime = dict["datetime"] as? String{
            self.strDateTime = datetime
        }
    }
    
}
