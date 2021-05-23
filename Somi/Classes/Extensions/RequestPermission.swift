//
//  RequestPermission.swift
//  Bang
//
//  Created by RohitSingh-MacMINI on 22/07/19.
//  Copyright © 2019 RohitSingh. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import CoreLocation
import Contacts


class RequestPermission: NSObject {
    
    //Default PopUp
    static func alertPromptToAllowCameraAccessViaSetting(strTitle:String,strMessage:String) {
        
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel) { (alert) -> Void in
            
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        
        alert.show()
    }
    
    //------------------------For Camera/Video---------------------------//
    static func checkCameraPermissions(handler:(Bool)->Void) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            print("Allowed")
            handler(true)
        case .denied:
            handler(false)
            alertPromptToAllowCameraAccessViaSetting(strTitle:"Camera access required",strMessage: "Camera access is disabled please allow from Settings.")
        default:
            print("Allowed")
            handler(true)
        }
    }
    
    //------------------------For Gallery---------------------------//
    
    static func checkPhotoLibraryPermission(handler:@escaping (Bool)->Void){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            handler(true)
        case .denied, .restricted :
            handler(false)
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    handler(true)
                    print("true")
                    
                case .denied, .restricted:
                    handler(false)
                    print("false")
                    alertPromptToAllowCameraAccessViaSetting(strTitle:"Gallery access required",strMessage: "Gallery access is disabled please allow from Settings.")
                    
                case .notDetermined:
                    alertPromptToAllowCameraAccessViaSetting(strTitle:"Gallery access required",strMessage: "Gallery access is disabled please allow from Settings.")
                @unknown default:
                    fatalError()
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    
    
    //-------------------------------For Location Access------------------------------------//
    
    
    class func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    
    
//    static func isLocationServiceEnabled(handler:(Bool)->Void) {
//        if CLLocationManager.locationServicesEnabled() {
//            switch(CLLocationManager.authorizationStatus()) {
//            case .notDetermined, .restricted, .denied:
//                handler(false)
//                alertPromptToAllowCameraAccessViaSetting(strTitle:"Location access required",strMessage: "Location access is disabled please allow from Settings.")
//            case .authorizedAlways, .authorizedWhenInUse:
//                handler(true)
//            default:
//                handler(false)
//                alertPromptToAllowCameraAccessViaSetting(strTitle:"Location access required",strMessage: "Location access is disabled please allow from Settings.")
//            }
//        } else {
//            alertPromptToAllowCameraAccessViaSetting(strTitle:"Location access required",strMessage: "Location access is disabled please allow from Settings.")
//            // AppSharedClass.shared.showAlert(title: "Alert", message: "Location services are not enabled")
//            handler(false)
//        }
//    }
    
    //-------------------------------------For Contact Access------------------------------------//
    
    static func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            let store = CNContactStore()
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    
    static func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: "Contact access required", message: "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
            completionHandler(false)
            // AppSharedClass.shared.isContactAccessGrantViaSetting = true
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        alert.show()
    }
    
    
    //----------------------------------------XXXXX-----------------------------------------//
    
    
//    static func locationAuthorization(){
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
//           // self.PlaceAPIWork()
//
//        }else if CLLocationManager.authorizationStatus() == .authorizedAlways{
//          //  self.PlaceAPIWork()
//        }
//        else if (CLLocationManager.authorizationStatus() == .denied) {
//            let alert = UIAlertController(title: "Need Authorization", message: "This app is unusable if you don't authorize this app to use your location!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
//                let url = URL(string: UIApplicationOpenSettingsURLString)!
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }))
//            self.present(alert, animated: true, completion: nil)
//        } else {
//          //  locManager.requestWhenInUseAuthorization()
//          //  self.PlaceAPIWork()
//        }
//    }
    
}

