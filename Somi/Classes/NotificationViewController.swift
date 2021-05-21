//
//  NotificationViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit

class NotificationViewController: UIViewController {

    //MARK:- IBoutlets
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var vwHeaderBg: UIView!
    @IBOutlet weak var vwBtnBg: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblReqType: UILabel!
    @IBOutlet var lbladdress: UILabel!
    @IBOutlet var lblTime: UILabel!
    
    var isComingfrom = ""
    var strReqID = ""
    var strLatitude = ""
    var strLongitude = ""
    
    //MARK:- App lyf Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

//        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
//        self.setStyling(strUserType: userType)
        
        self.call_WSNotificationDetail(strReqID: self.strReqID)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
        }else{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }
    
    //MARK:- IBAction
    @IBAction func actionBtnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionBtnTrack(_ sender: Any) {
        self.openMaps(latitude: Double(strLatitude) ?? 0.0, longitude: Double(strLongitude) ?? 0.0, title: "Location")
        
    }
    @IBAction func actionBtnShare(_ sender: Any) {
        //Set the default sharing message.
        let message = "Message goes here."
        //Set the link to share.
        if let link = NSURL(string: "http://yoururl.com")
        {
            let objectsToShare = [message,link] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func openMaps(latitude: Double, longitude: Double, title: String?) {
        let application = UIApplication.shared
        let coordinate = "\(latitude),\(longitude)"
        let encodedTitle = title?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let handlers = [
            ("Apple Maps", "http://maps.apple.com/?q=\(encodedTitle)&ll=\(coordinate)"),
            ("Google Maps", "comgooglemaps://?q=\(coordinate)"),
            ("Waze", "waze://?ll=\(coordinate)"),
            ("Citymapper", "citymapper://directions?endcoord=\(coordinate)&endname=\(encodedTitle)")
        ]
            .compactMap { (name, address) in URL(string: address).map { (name, $0) } }
            .filter { (_, url) in application.canOpenURL(url) }

        guard handlers.count > 1 else {
            if let (_, url) = handlers.first {
                application.open(url, options: [:])
            }
            return
        }
        let alert = UIAlertController(title: "Select Map", message: nil, preferredStyle: .actionSheet)
        handlers.forEach { (name, url) in
            alert.addAction(UIAlertAction(title: name, style: .default) { _ in
                application.open(url, options: [:])
            })
        }
        alert.addAction(UIAlertAction(title: "Choose", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}


//MARK:- Call WebService Notification

extension NotificationViewController{
        
    func call_WSNotificationDetail(strReqID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_request_id":strReqID,
                        ]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_NotificationDeatil, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for data in arrData{
                        
                        self.lbladdress.text = data["address"]as? String ?? ""
                        self.lblName.text = data["name"]as? String ?? ""
                        self.lblReqType.text = data["category_name"]as? String ?? ""
                        self.lblTime.text = data["datetime"]as? String ?? ""
                        
                        
                        self.strLatitude = data["lat"]as? String ?? ""
                        print(self.strLatitude)
                        self.strLongitude = data["lng"]as? String ?? ""
                        print(self.strLongitude)
                        
                        let profilePic = data["user_image"]as? String ?? ""
                        
                        if profilePic != "" {
                            let url = URL(string: profilePic)
                            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
                        }
                        
                    }

                   
                }

                
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
           
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
}
