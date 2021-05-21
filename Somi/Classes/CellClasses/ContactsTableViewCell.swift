//
//  ContactsTableViewCell.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var vwAddRemove: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet var btnSave: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgVwUser.makeCircleImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


