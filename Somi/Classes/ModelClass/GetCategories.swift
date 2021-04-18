//
//  GetCategories.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 28/03/21.
//

import UIKit

class GetCategories: NSObject {
    
    var strCategoryID:String = ""
    var strCategoryName:String = ""
    var strCategoryImage:String = ""
    

    init(dict : [String:Any]) {
        
        if let categoryID = dict["category_id"] as? String{
            self.strCategoryID = categoryID
        }else  if let categoryID = dict["category_id"] as? Int{
            self.strCategoryID = "\(categoryID)"
        }
        
        if let catName = dict["category_name"] as? String{
            self.strCategoryName = catName
        }
        
        if let catImage = dict["category_image"] as? String{
            self.strCategoryImage = catImage
        }
        
        
    }
}
