//
//  MemberShipModel.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 15/05/21.
//

import UIKit

class MemberShipModel: NSObject {

    var strPlanID = ""
    var strPlanTitle = ""
    var strPrice = ""
    var strValidity = ""
    
    init(dict : [String:Any]) {
        
        if let plan_id = dict["plan_id"] as? String{
            self.strPlanID = plan_id
        }else if let plan_id = dict["plan_id"] as? Int{
            self.strPlanID = "\(plan_id)"
        }
        
        if let price = dict["price"] as? String{
            self.strPrice = price
        }else if let price = dict["price"] as? Int{
            self.strPrice = "\(price)"
        }
        
        if let validity = dict["validity"] as? String{
            self.strValidity = validity
        }else if let validity = dict["validity"] as? Int{
            self.strValidity = "\(validity)"
        }
        
        if let plan_title = dict["plan_title"] as? String{
            self.strPlanTitle = plan_title
        }
        
    }
}
