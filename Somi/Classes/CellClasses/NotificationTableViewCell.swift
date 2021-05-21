//
//  NotificationTableViewCell.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 02/05/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblTimeAgo: UILabel!
    @IBOutlet var imgVw: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
