//
//  LaunchViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 01/04/21.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var imgVwLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
//        self.setStyling(strUserType: userType)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.imgVwLogo.image = #imageLiteral(resourceName: "blue_logo")
            
        }else{
            self.imgVwLogo.image = #imageLiteral(resourceName: "pink_logo")
        }
    }
    
}
