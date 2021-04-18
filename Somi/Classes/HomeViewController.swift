//
//  HomeViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit
import CoreLocation
import MessageUI

class HomeViewController: UIViewController,MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var vwHeaderBg: UIView!
    @IBOutlet weak var imgVwLogo: UIImageView!
    @IBOutlet weak var vwBtnBg: UIView!
    @IBOutlet weak var lblCurrentLocation: UILabel!
    @IBOutlet weak var vwBnBgText: UIView!
    @IBOutlet weak var btnText: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var subVwBloodGroup: UIView!
    @IBOutlet weak var vwContainerBloodGroup: UIView!
    @IBOutlet weak var lblBloodGroup: UILabel!
    @IBOutlet weak var lblAllergies: UILabel!
    
    var locationManager:CLLocationManager!
    var latitude = ""
    var longitude = ""
    var emergenyNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
       
        
        self.subVwBloodGroup.isHidden = true
        self.vwContainerBloodGroup.clipsToBounds = true
        self.vwContainerBloodGroup.layer.cornerRadius = 5
        
        self.emergenyNumber = objAppShareData.UserDetail.strEmergencyNumber
        self.btnCall.setTitle("CALL \(emergenyNumber)", for: .normal)
        self.btnText.setTitle("TEXT \(emergenyNumber)", for: .normal)
    }
    
    func locationSetup(){
        locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()

            if CLLocationManager.locationServicesEnabled(){
                locationManager.startUpdatingLocation()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationSetup()
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.vwBnBgText.backgroundColor = UIColor.init(named: "appBlueColor")
            self.imgVwLogo.image = #imageLiteral(resourceName: "blue_logo")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
            
        }else{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.vwBnBgText.backgroundColor = UIColor.init(named: "appPinkColor")
            self.imgVwLogo.image = #imageLiteral(resourceName: "pink_logo")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }
    
    @IBAction func btnGoToReqType(_ sender: Any) {
        
        if self.latitude != "" && self.longitude != "" && self.lblCurrentLocation.text != ""{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RequestTypeViewController")as! RequestTypeViewController
            vc.strLatitude = self.latitude
            vc.strLongitude = self.longitude
            vc.strAddress = self.lblCurrentLocation.text!
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            objAlert.showAlert(message: "Current Addres not found", title: "Alert", controller: self)
        }
        
        
    }
    
    
    @IBAction func actionbtnCall911(_ sender: Any) {
        self.callNumber(phoneNumber: self.emergenyNumber )
    }
    @IBAction func actionBtnText(_ sender: Any) {
        
        if let msg = UserDefaults.standard.string(forKey: "emergency_message"){
            if (MFMessageComposeViewController.canSendText()) {
                self.lblBloodGroup.text = objAppShareData.UserDetail.strBloodGroup
                self.lblAllergies.text = objAppShareData.UserDetail.strAllergy
                self.subVwBloodGroup.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.subVwBloodGroup.isHidden = true
                    let controller = MFMessageComposeViewController()
                    controller.body = msg
                    controller.recipients = [self.emergenyNumber]
                    controller.messageComposeDelegate = self
                 self.present(controller, animated: true, completion: nil)
                    
                }
                  
               }
        }else{
            objAlert.showAlert(message: "Please set default message first", title: "Alert", controller: self)
        }
        
       
    }
    
//    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
//           let messageComposeVC = MFMessageComposeViewController()
//           messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
//           messageComposeVC.recipients = ["911"]
//         //  messageComposeVC.body = "Hello! Welcome to Goodburger home of the Goodburger can I take your order"
//           return messageComposeVC
//       }
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResult.cancelled.rawValue:
            print("Message was cancelled")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.failed.rawValue:
            print("Message failed")
            self.dismiss(animated: true, completion: nil)
        case MessageComposeResult.sent.rawValue:
            print("Message was sent")
            self.dismiss(animated: true, completion: nil)
        default:
            break;
        }
    }
    
    @IBAction func actionbtnOpenSideMenu(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuViewController")as! SideMenuViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func callNumber(phoneNumber: String) {
        guard let url = URL(string: "telprompt://\(phoneNumber)"),
            UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}


extension HomeViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        self.locationManager.stopUpdatingLocation()
        
        self.latitude = "\(userLocation.coordinate.latitude)"
        self.longitude = "\(userLocation.coordinate.longitude)"
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                self.lblCurrentLocation.text = "Current Location not detected."
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
                print(placemark.administrativeArea!)
                print(placemark.country!)

               // self.lblCurrentLocation.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.lblCurrentLocation.text = "Moscow, Moscow Oblast, Russia"
                }
                
            }
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}
