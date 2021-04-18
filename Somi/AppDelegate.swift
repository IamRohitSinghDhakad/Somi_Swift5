//
//  AppDelegate.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 22/03/21.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

let ObjAppdelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    var navController: UINavigationController?
    
    private static var AppDelegateManager: AppDelegate = {
          let manager = UIApplication.shared.delegate as! AppDelegate
          return manager
      }()
      // MARK: - Accessors
      class func AppDelegateObject() -> AppDelegate {
          return AppDelegateManager
     }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        
        self.registerForRemoteNotification()
        Messaging.messaging().delegate = self
        
        (UIApplication.shared.delegate as? AppDelegate)?.self.window = window
        
        self.checkLoginStatus()
        
        return true
    }

  
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("did become active")
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("did enter background")
    }
    

}


extension AppDelegate{
    
    func checkLoginStatus(){
        if  let userID = UserDefaults.standard.value(forKey: UserDefaults.Keys.userID)as? String {
            print(userID)
            self.call_GetProfile(strUserID: userID)
        }else{
            self.LaunchNavigation()
        }
    }
    
    func LaunchNavigation(){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        navController = sb.instantiateViewController(withIdentifier: "LaunchNav") as? UINavigationController
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func LoginNavigation(){
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        navController = sb.instantiateViewController(withIdentifier: "LoginNav") as? UINavigationController
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    func HomeNavigation() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "HoneNaV") as? UINavigationController
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
}

//MARK:- notification setup
extension AppDelegate:UNUserNotificationCenterDelegate{
    func registerForRemoteNotification() {
        // iOS 10 support
        if #available(iOS 10, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options:authOptions){ (granted, error) in
                UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
                Messaging.messaging().delegate = self
                let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [], intentIdentifiers: [], options: [])
                let center = UNUserNotificationCenter.current()
                center.setNotificationCategories(Set([deafultCategory]))
            }
        }else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector:
            #selector(tokenRefreshNotification), name:
            .InstanceIDTokenRefresh, object: nil)
    }
}

//MARK: - FireBase Methods / FCM Token
extension AppDelegate : MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
     //   objAppShareData.strFirebaseToken = fcmToken ?? ""
    }

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
      //  objAppShareData.strFirebaseToken = fcmToken
        ConnectToFCM()
    }
    
    @objc func tokenRefreshNotification(_ notification: Notification) {
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let result = result {
                print("Remote instance ID token: \(result.token)")
               // objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(result.token)")
            }
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        ConnectToFCM()
    }
    
    func ConnectToFCM() {
        InstanceID.instanceID().instanceID { (result, error) in
            
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            }else if let result = result {
                print("Remote instance ID token: \(result.token)")
             //   objAppShareData.strFirebaseToken = result.token
                print("objAppShareData.firebaseToken = \(result.token)")
            }
        }
    }

    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if let userInfo = notification.request.content.userInfo as? [String : Any]{
            print(userInfo)
            var notificationType = ""
            var bookingID = ""
            
            if let type = userInfo["type"] as? Int{
                notificationType = String(type)
            }else if let type = userInfo["type"] as? String{
                notificationType = type
            }
                    
            if let id = userInfo["reference_id"] as? Int{
                bookingID = String(id)
            }else if let id = userInfo["reference_id"] as? String{
                bookingID = id
            }
         //   objAppShareData.notificationDict = userInfo
            self.navWithNotification(type: notificationType, bookingID: bookingID)
        }
        completionHandler([.alert,.sound,.badge])
    }
    
    
    func navWithNotification(type:String,bookingID:String){
//        let topController = self.topViewController()
//        //print(topController?.restorationIdentifier)
//        if type == "1" && (topController?.restorationIdentifier == "Ridedetail_VC") && bookingID == objAppShareData.holdBookingID{
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshDetail"), object: nil)
//
//        }else if type == "1" && (objAppShareData.isONMainList == true){
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMainList"), object: nil)
//
//        }else if type == "1" && (topController?.restorationIdentifier == "Expire_CompleteRides_VC"){
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshExpiredCmpltList"), object: nil)
//
//        }else if type == "5" && (topController?.restorationIdentifier == "Companylist_VC"){
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshCompanyList"), object: nil)
//
//        }else if objAppShareData.holdVCIndex == "1" || objAppShareData.holdVCIndex == "2"{
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshCompanyList"), object: nil)
//        }
    }

    //TODO: called When you tap on the notification in background
   @available(iOS 10.0, *)
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
       print(response)
       switch response.actionIdentifier {
       case UNNotificationDismissActionIdentifier:
           print("Dismiss Action")
       case UNNotificationDefaultActionIdentifier:
           print("Open Action")
           if let userInfo = response.notification.request.content.userInfo as? [String : Any]{
               print(userInfo)
               self.handleNotificationWithNotificationData(dict: userInfo)
           }
       case "Snooze":
           print("Snooze")
       case "Delete":
           print("Delete")
       default:
           print("default")
       }
       completionHandler()
   }
    
    func handleNotificationWithNotificationData(dict:[String:Any]){
        var strType = ""
        var bookingID = ""
        if let notiType = dict["notification_type"] as? String{
            strType = notiType
        }
        if let type = dict["type"] as? Int{
            strType = String(type)
        }else if let type = dict["type"] as? String{
            strType = type
        }
                
        if let id = dict["reference_id"] as? Int{
            bookingID = String(id)
        }else if let id = dict["reference_id"] as? String{
            bookingID = id
        }
//        objAppShareData.notificationDict = dict
//        objAppShareData.isFromNotification = true
//        objAppShareData.notificationType = strType
//        self.homeNavigation(animated: false)
    }
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}



public extension UIWindow {

    var visibleViewController: UIViewController? {

        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)

    }

    static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {

        if let nc = vc as? UINavigationController {

            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)

        } else if let tc = vc as? UITabBarController {

            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)

        } else {

            if let pvc = vc?.presentedViewController {

                return UIWindow.getVisibleViewControllerFrom(vc: pvc)

            } else {

                return vc

            }

        }

    }

}

extension AppDelegate{
    func call_GetProfile(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
           // objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: )
            self.showAlerOnAppDelegate(strMessage: "No Internet Connection")
            return
        }
    
      //  objWebServiceManager.showIndicator()
        
       
        
        let dicrParam = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                let user_details  = response["result"] as? [String:Any]

                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                ObjAppdelegate.HomeNavigation()
                
                
            }else{
                objWebServiceManager.hideIndicator()
              //  self.showAlerOnAppDelegate(strMessage: message ?? "Failed")
                self.showAlertCallBack(alertLeftBtn: "OK", alertRightBtn: "", title: "Alert", message: message ?? "Session expired") {
                    self.LoginNavigation()
                }
                }
           
            
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }

    
   }
    
    func showAlerOnAppDelegate(strMessage: String){
        let alert = UIAlertController(title: "Alert", message: strMessage, preferredStyle: UIAlertController.Style.alert)
                
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
               
        // show the alert
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func showAlertCallBack(alertLeftBtn:String, alertRightBtn:String,  title: String, message: String , callback: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title:alertLeftBtn, style: .destructive, handler: {
          alertAction in
        
        }))

         alert.addAction(UIAlertAction(title: alertRightBtn, style: .default, handler: {
           alertAction in
           callback()
         }))
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
       }
}


/*
 //
 //  AppDelegate.swift
 //  ReserVision
 //
 //  Created by Narendra-macbook on 03/11/20.
 //  Copyright © 2020 MINDIII. All rights reserved.
 //

 import UIKit
 import IQKeyboardManagerSwift
 import GoogleSignIn
 import SlideMenuControllerSwift
 import GoogleMaps
 import GooglePlaces
 import Firebase
 import FirebaseCore
 import FirebaseMessaging

 let ObjAppdelegate = AppDelegate.AppDelegateObject()

 @UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?
     
     private static var AppDelegateManager: AppDelegate = {
           let manager = UIApplication.shared.delegate as! AppDelegate
           return manager
       }()
       // MARK: - Accessors
       class func AppDelegateObject() -> AppDelegate {
           return AppDelegateManager
      }

     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         // Override point for customization after application launch.
         UNUserNotificationCenter.current().delegate = self

         IQKeyboardManager.shared.enable = true
         IQKeyboardManager.shared.enableAutoToolbar = true
         IQKeyboardManager.shared.shouldResignOnTouchOutside = true
         SlideMenuOptions.leftViewWidth = self.window?.frame.width ?? 0.0
         //SlideMenuOptions.tapGesturesEnabled = true
         
         
         ///////
         self.gPlistInfoSetup()
         self.registerForRemoteNotification()
         Messaging.messaging().delegate = self

         self.manageHomeNavigation()
         // insert this line if it is not there
         (UIApplication.shared.delegate as? AppDelegate)?.self.window = window
                
         return true
     }
     
     func gPlistInfoSetup(){
         if BASE_URL.contains("dev"){
             print("devvv")
             let firebaseConfig = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")
             guard let options = FirebaseOptions(contentsOfFile: firebaseConfig!) else {
                 fatalError("Invalid Firebase configuration file.")
             }
             FirebaseApp.configure(options: options)
             
         }else{
             print("liveee")
             let firebaseConfig = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
             guard let options = FirebaseOptions(contentsOfFile: firebaseConfig!) else {
                 fatalError("Invalid Firebase configuration file.")
             }
             FirebaseApp.configure(options: options)
         }
     }
     
     func LoginNavigation(){
        self.removeUserdefaults()
        let login = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login_VC") as! Login_VC
        let nav = UINavigationController(rootViewController: login)
        nav.setNavigationBarHidden(true, animated: true)
        self.window?.rootViewController = nav
     }
     
     func homeNavigation(animated:Bool){
         let HomeVC = UIStoryboard(name: "Rides", bundle: nil).instantiateViewController(withIdentifier: "Ridelist_VC") as! Ridelist_VC
         let LeftSlideMenuVC = UIStoryboard(name: "Rides", bundle: nil).instantiateViewController(withIdentifier: "LeftSideMenu_VC") as! LeftSideMenu_VC
         let menuController = SlideMenuController (mainViewController: HomeVC, leftMenuViewController: LeftSlideMenuVC)
         
         SlideMenuOptions.contentViewScale = 1
         SlideMenuOptions.tapGesturesEnabled = true
         let nav_home = UINavigationController(rootViewController: menuController)
         nav_home.setNavigationBarHidden(true, animated: animated)
         self.window?.endEditing(true)
        
         self.window?.rootViewController = nav_home
         self.window?.makeKeyAndVisible()
     }
     
     func manageHomeNavigation(){
         let auth = UserDefaults.standard.string(forKey: UserDefaults.Keys.AuthToken) ?? ""
         
         let strOnboarding = UserDefaults.standard.string(forKey: UserDefaults.Keys.onBoarding) ?? ""
         let strnextStep = UserDefaults.standard.string(forKey: UserDefaults.Keys.vehicleStep) ?? ""
         
         if auth == "" {
             self.LoginNavigation()
         }else if auth != "" && strOnboarding == "1"{
             
             if strnextStep == "1" {
                 self.homeNavigation(animated: true)
             }else{
                 //self.LoginNavigation()
                 let Vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Companylist_VC") as! Companylist_VC
                 let nav = UINavigationController(rootViewController: Vc)
                 nav.setNavigationBarHidden(true, animated: true)
                 self.window?.rootViewController = nav
             }
           
         }else {
             self.LoginNavigation()
         }
         
     }
     
     func removeUserdefaults(){
         //for clear pending notification
 //        let center = UNUserNotificationCenter.current()
 //        center.removeAllDeliveredNotifications()
 //        center.removeAllPendingNotificationRequests()
         
         GIDSignIn.sharedInstance().signOut()
         userDefaults.removeObject(forKey: UserDefaults.Keys.AuthToken)
         userDefaults.removeObject(forKey: UserDefaults.Keys.onBoarding)
         userDefaults.removeObject(forKey: UserDefaults.Keys.full_name)
         userDefaults.removeObject(forKey: UserDefaults.Keys.vehicleStep)
         
     }
     

     // MARK: UISceneSession Lifecycle

 //    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
 //        // Called when a new scene session is being created.
 //        // Use this method to select a configuration to create the new scene with.
 //        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
 //    }

 //    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
 //        // Called when the user discards a scene session.
 //        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
 //        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
 //    }

     func applicationDidBecomeActive(_ application: UIApplication) {
         print("did become active")
     }
     func applicationDidEnterBackground(_ application: UIApplication) {
         print("did enter background")
     }
     
     func applicationWillEnterForeground(_ application: UIApplication) {
         print("will enter forground")
         let topController = self.topViewController()
         print("objAppShareData.holdVCIndex \(objAppShareData.holdVCIndex)")
         print("TopViewVC is === \(topController?.restorationIdentifier)")
         
         if topController?.restorationIdentifier == "Ridedetail_VC"{
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshDetail"), object: nil)
             
         }else if objAppShareData.isONMainList == true{
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMainList"), object: nil)
             
         }else if topController?.restorationIdentifier == "Expire_CompleteRides_VC"{
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshExpiredCmpltList"), object: nil)
             
         }else if objAppShareData.holdVCIndex == "1" || objAppShareData.holdVCIndex == "2"{
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshCompanyList"), object: nil)
         }
     }
 }

 //MARK:- notification setup
 extension AppDelegate:UNUserNotificationCenterDelegate{
     func registerForRemoteNotification() {
         // iOS 10 support
         if #available(iOS 10, *) {
             let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
             UNUserNotificationCenter.current().requestAuthorization(options:authOptions){ (granted, error) in
                 UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
                 Messaging.messaging().delegate = self
                 let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [], intentIdentifiers: [], options: [])
                 let center = UNUserNotificationCenter.current()
                 center.setNotificationCategories(Set([deafultCategory]))
             }
         }else {
             
             let settings: UIUserNotificationSettings =
                 UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
             UIApplication.shared.registerUserNotificationSettings(settings)
         }
         UIApplication.shared.registerForRemoteNotifications()
         NotificationCenter.default.addObserver(self, selector:
             #selector(tokenRefreshNotification), name:
             .InstanceIDTokenRefresh, object: nil)
     }
 }

 //MARK: - FireBase Methods / FCM Token
 extension AppDelegate : MessagingDelegate{
    
     func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
         print("Firebase registration token: \(fcmToken)")
         objAppShareData.strFirebaseToken = fcmToken ?? ""
     }

     func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
         objAppShareData.strFirebaseToken = fcmToken
         ConnectToFCM()
     }

     @objc func tokenRefreshNotification(_ notification: Notification) {
         
         InstanceID.instanceID().instanceID { (result, error) in
             if let error = error {
                 print("Error fetching remote instange ID: \(error)")
             }else if let result = result {
                 print("Remote instance ID token: \(result.token)")
                 objAppShareData.strFirebaseToken = result.token
                 print("objAppShareData.firebaseToken = \(result.token)")
             }
         }
         // Connect to FCM since connection may have failed when attempted before having a token.
         ConnectToFCM()
     }

     func ConnectToFCM() {
         InstanceID.instanceID().instanceID { (result, error) in
             
             if let error = error {
                 print("Error fetching remote instange ID: \(error)")
             }else if let result = result {
                 print("Remote instance ID token: \(result.token)")
                 objAppShareData.strFirebaseToken = result.token
                 print("objAppShareData.firebaseToken = \(result.token)")
             }
         }
     }

     @available(iOS 10.0, *)
     func userNotificationCenter(_ center: UNUserNotificationCenter,
                                 willPresent notification: UNNotification,
                                 withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
         
         if let userInfo = notification.request.content.userInfo as? [String : Any]{
             print(userInfo)
             var notificationType = ""
             var bookingID = ""
             
             if let type = userInfo["type"] as? Int{
                 notificationType = String(type)
             }else if let type = userInfo["type"] as? String{
                 notificationType = type
             }
                     
             if let id = userInfo["reference_id"] as? Int{
                 bookingID = String(id)
             }else if let id = userInfo["reference_id"] as? String{
                 bookingID = id
             }
             objAppShareData.notificationDict = userInfo
             self.navWithNotification(type: notificationType, bookingID: bookingID)
         }
         completionHandler([.alert,.sound,.badge])
     }
     
     func navWithNotification(type:String,bookingID:String){
         let topController = self.topViewController()
         //print(topController?.restorationIdentifier)
         if type == "1" && (topController?.restorationIdentifier == "Ridedetail_VC") && bookingID == objAppShareData.holdBookingID{
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshDetail"), object: nil)
             
         }else if type == "1" && (objAppShareData.isONMainList == true){
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMainList"), object: nil)
             
         }else if type == "1" && (topController?.restorationIdentifier == "Expire_CompleteRides_VC"){
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshExpiredCmpltList"), object: nil)
             
         }else if type == "5" && (topController?.restorationIdentifier == "Companylist_VC"){
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshCompanyList"), object: nil)
             
         }else if objAppShareData.holdVCIndex == "1" || objAppShareData.holdVCIndex == "2"{
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshCompanyList"), object: nil)
         }
     }

     //TODO: called When you tap on the notification in background
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        print(response)
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
            if let userInfo = response.notification.request.content.userInfo as? [String : Any]{
                print(userInfo)
                self.handleNotificationWithNotificationData(dict: userInfo)
            }
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
    }
     
     func handleNotificationWithNotificationData(dict:[String:Any]){
         var strType = ""
         var bookingID = ""
         if let notiType = dict["notification_type"] as? String{
             strType = notiType
         }
         if let type = dict["type"] as? Int{
             strType = String(type)
         }else if let type = dict["type"] as? String{
             strType = type
         }
                 
         if let id = dict["reference_id"] as? Int{
             bookingID = String(id)
         }else if let id = dict["reference_id"] as? String{
             bookingID = id
         }
         objAppShareData.notificationDict = dict
         objAppShareData.isFromNotification = true
         objAppShareData.notificationType = strType
         self.homeNavigation(animated: false)
     }
     
     func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
         if let navigationController = controller as? UINavigationController {
             return topViewController(controller: navigationController.visibleViewController)
         }
         if let tabController = controller as? UITabBarController {
             if let selected = tabController.selectedViewController {
                 return topViewController(controller: selected)
             }
         }
         if let presented = controller?.presentedViewController {
             return topViewController(controller: presented)
         }
         return controller
     }
 }

 **/
