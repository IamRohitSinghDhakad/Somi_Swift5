//
//  WebServiceClass.swift
//  Link
//
//  Created by MINDIII on 10/3/17.
//  Copyright © 2017 MINDIII. All rights reserved.


import UIKit
import Alamofire
import SVProgressHUD


var strAuthToken : String = ""

//let stripeKey = "Bearer sk_test_51HICutF4Ydv5uQBCGnB3HEsk1BT0XBJJyN8PWI42sbJGbX29RpCmHCkCo7eVsXUujHQklGnEjYkl6ds3KlkAl2uC00voSWZlLc"


let objWebServiceManager = WebServiceManager.sharedObject()

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class WebServiceManager: NSObject {
    
    //MARK:- Shared object
    
    fileprivate var window = UIApplication.shared.keyWindow
    
    private static var sharedNetworkManager: WebServiceManager = {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setRingThickness(3)
        SVProgressHUD.setRingRadius(22)
        
        let networkManager = WebServiceManager()
        return networkManager
    }()
    
    // MARK: - Accessors
    class func sharedObject() -> WebServiceManager {
        return sharedNetworkManager
    }
    
    //    private let manager: Alamofire.SessionManager = {
    //        let configuration = URLSessionConfiguration.default
    //        return Alamofire.SessionManager(configuration: configuration)
    //    }()
        
    func isNetworkAvailable() -> Bool{
        if !NetworkReachabilityManager()!.isReachable{
            return false
        }else{
            return true
        }
    }
    
    func showNetworkAlert(){
        let alert = UIAlertController(title:"No network" , message:"Please check your internet connection." , preferredStyle: .alert)
        let action = UIAlertAction(title:"OK", style: .default, handler: nil)
        alert.addAction(action)
        alert.show()
    }
    
    func queryString(_ value: String, params: [String: Any]) -> String? {
        var components = URLComponents(string: value)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value as? String ) }
        
        return components?.url?.absoluteString
    }
    
    //MARK:- Show/hide Indicator
    func showIndicator(){
        self.window?.isUserInteractionEnabled = false
        //DispatchQueue.main.async {
        SVProgressHUD.show()
        //}
    }
    
    func hideIndicator(){
        self.window?.isUserInteractionEnabled = true
        
        //DispatchQueue.main.async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            // do stuff 4 seconds later
            SVProgressHUD.dismiss()
            
        }
        //}
    }
    //get current timezone
    func getCurrentTimeZone() -> String{
        return TimeZone.current.identifier
    }
}

//MARK:- Webservice methods
extension WebServiceManager {
    
    //MARK: - Request Post method ----
    
    public func requestPost(strURL:String,queryParams : [String:Any], params : [String:Any], strCustomValidation:String , showIndicator:Bool, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void) {
        if !objWebServiceManager.isNetworkAvailable(){
            //objWebServiceManager.hideIndicator()
            //objAppShareData.showNetworkAlert()
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken){
            strAuthToken = token
        }
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        _ = strUdidi
        _ = getCurrentTimeZone()
        
        
        let header: HTTPHeaders = [
            "authToken": strAuthToken ,
            "Accept": "application/json"]
        
        //  content-type →application/json
        // "Accept": "application/json",
        //        WsHeader.deviceId:strUdidi,
        //        WsHeader.deviceType:"1",
        //        WsHeader.deviceTimeZone: currentTimeZone
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable )
            print("pathvariablepathvariable.....\(pathvariable )")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(strURL, params: queryParams ) ?? ""
        }
        
        else{
            StrCompleteUrl = strURL
        }
        print(StrCompleteUrl)
        //  print(header)
        print(params)
        AF.request(StrCompleteUrl,method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON { response in
            
            print(response.result)
            switch response.result{
            
            case .success(let json):
                //  do {
                
                let dictionary = json as! [String:Any]
                if let message = dictionary["message"] as? String{
                    if message == "Invalid Auth Token" {
                        ObjAppdelegate.LoginNavigation()
                    }
                    
                }
                
                if let errorCode = dictionary["status_code"] as? Int{
                    let strErrorType = dictionary["error_type"] as? String ?? ""
                    let strMessage1 = dictionary["message"] as? String ?? ""
                    if errorCode == 400{
                        
                        if strErrorType == "USER_NOT_FOUND" || strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                            //    objAppShareData.showSessionFailAlert()
                            return
                        }else{
                            //objAppShareData.showErrorAlert(strMessage:strMessage1)
                        }
                    }
                }
                
                success(dictionary)
                
            case .failure(let encodingError):
                // let error : Error = response.error!
                failure(encodingError)
                //  let str =   response.data?.base64EncodedString(options: .endLineWithLineFeed)//String(decoding: response.data as? NSData, as: UTF8.self)
                print("PHP ERROR :",encodingError.errorDescription as Any)
            }
        }
    }
    
    //MARK: - Request Put method ----
    public func requestPut(strURL:String, params : [String:Any]?,strCustomValidation:String,showIndicator:Bool, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            //objAppShareData.showNetworkAlert()
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken){
            strAuthToken = "Bearer " + token
        }
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        let currentTimeZone = getCurrentTimeZone()
        let header: HTTPHeaders = ["Authorization":strAuthToken,
                                   WsHeader.deviceId:strUdidi,
                                   WsHeader.deviceType:"1",
                                   WsHeader.deviceTimeZone: currentTimeZone,
                                   WsHeader.ContentType: "application/x-www-form-urlencoded"]
        print(header)
        
        AF.request(strURL, method: .put, parameters:  params, encoding: URLEncoding.default, headers: header).responseJSON{ response in
            
            print(response )
            
            switch response.result{
            
            case .success(let json):
                //  do {
                let dictionary = json as! [String:Any]
                
                if let message = dictionary["message"] as? String{
                    if message == "Invalid Auth Token" {
                        ObjAppdelegate.LoginNavigation()
                    }
                }
                
                if let errorCode = dictionary["status_code"] as? Int{
                    let strErrorType = dictionary["error_type"] as? String ?? ""
                    _ = dictionary["message"] as? String ?? ""
                    if errorCode == 400{
                        
                        if strErrorType == "USER_NOT_FOUND" || strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                            // objAppShareData.showSessionFailAlert()
                            return
                            
                        }else{
                            //objAppShareData.showErrorAlert(strMessage:strMessage1)
                        }
                    }
                }
                success(dictionary as! Dictionary<String, Any>)
            case .failure(let encodingError):
                print("PHP error",encodingError)
                failure(encodingError)
            }
        }
    }
    
    //MARK: - Request get method ----
    public func requestGet(strURL:String, params : [String:Any]? ,queryParams : [String:Any], strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            // objAppShareData.showNetworkAlert()
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken){
            strAuthToken =  token //"Bearer" + " " +
        }
        
        _ = getCurrentTimeZone()
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        _ = strUdidi
        let headers: HTTPHeaders = [
            "authToken": strAuthToken ,
            "Accept": "application/json"]
        
        print("url....\(strURL)")
        print("header....\(headers)")
        //
        let urlString = strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        var StrCompleteUrl = ""
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(urlString)"   + (pathvariable)
            print("pathvariablepathvariable.....\(pathvariable)")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(urlString, params: queryParams ) ?? ""
        }
        else{
            StrCompleteUrl = urlString
        }
        AF.request(StrCompleteUrl, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            //print(responseObject)
            
            switch responseObject.result{
            
            case .success(let json):
                do {
                    let dictionary = json as! NSDictionary
                    
                    if let message = dictionary["message"] as? String{
                        if message == "Invalid Auth Token" {
                            ObjAppdelegate.LoginNavigation()
                        }
                    }
                    
                    if let errorCode = dictionary["status_code"] as? Int{
                        let strErrorType = dictionary["error_type"] as? String ?? ""
                        _ = dictionary["message"] as? String ?? ""
                        if errorCode == 400{
                            
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                // objAppShareData.showSessionFailAlert()
                                return
                                
                            }else{
                                if strErrorType != "INVALID_USERNAME"{
                                    // objAppShareData.showErrorAlert(strMessage:strMessage1)
                                }
                            }
                        }
                    }
                    success(dictionary as! Dictionary<String, Any>)
                }
                
            case .failure(let encodingError):
                print("PHP error",encodingError.errorDescription as Any)
                failure(encodingError)
            }
        }
    }
    
    //MARK: - Request Delete method ----
    public func requestDelete(strURL:String, params : [String : AnyObject]?,queryParams : [String:Any], strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            //  objAppShareData.showNetworkAlert()
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            WsHeader.ContentType: "application/x-www-form-urlencoded",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable)
            print("pathvariablepathvariable.....\(pathvariable)")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(strURL, params: queryParams ) ?? ""
        }
        else{
            StrCompleteUrl = strURL
        }
        
        print("url....\(strURL)")
        print("header....\(headers)")
        AF.request(StrCompleteUrl, method: .delete, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            print(responseObject)
            
            switch responseObject.result{
            
            case .success(let json):
                do {
                    let dictionary = json as! NSDictionary
                    
                    if let message = dictionary["message"] as? String{
                        if message == "Invalid Auth Token" {
                            ObjAppdelegate.LoginNavigation()
                        }
                    }
                    
                    if let errorCode = dictionary["status_code"] as? Int{
                        let strErrorType = dictionary["error_type"] as? String ?? ""
                        _ = dictionary["message"] as? String ?? ""
                        if errorCode == 400{
                            
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                //  objAppShareData.showSessionFailAlert()
                                return
                                
                            }else{
                                // objAppShareData.showErrorAlert(strMessage:strMessage1)
                            }
                        }
                    }
                    success(dictionary as! Dictionary<String, Any>)
                }
            case .failure(let encodingError):
                print("PHP error",encodingError)
                failure(encodingError)
            }
        }
    }
    
    // //MARK: - upload MultipartData method ---
    
    public func uploadMultipartMultipleImagesData(strURL:String, params : [String:Any]?,showIndicator:Bool , customValidation:String, imageData:Data?,imageToUpload:[Data],imagesParam:[String], fileName:String?, mimeType:String?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void){
        
        
        if !NetworkReachabilityManager()!.isReachable{
            let app = UIApplication.shared.delegate as? AppDelegate
            _ = app?.window
            //  objAlert.showAlertVc(title: k_noNetwork, controller: window!)
            //                DispatchQueue.main.async {
            //                    self.StopIndicator()
            //                }
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken) {
            
            strAuthToken =  token //"Bearer" + " " +
        }
        
        let header: HTTPHeaders = ["authToken": strAuthToken ,
                                   "Accept": "application/json",
                                   "Content-Type": "application/x-www-form-urlencoded"]
        print(header)
        print(strURL)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            let count = imageToUpload.count
            for i in 0..<count{
                multipartFormData.append(imageToUpload[i], withName: "\(imagesParam[i])", fileName: "file\(i).png" , mimeType: "image/png")
            }
            
            for (key, value) in params ?? [:]{
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: strURL,usingThreshold: UInt64.init(), method: .post,headers: header).response{ response in
            
            switch response.result{
            
            case .success( _):
                
                do {
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        
                        
                        let dictionary = parsedData as NSDictionary
                        
                        if let message = dictionary["message"] as? String{
                            if message == "Invalid Auth Token" {
                                ObjAppdelegate.LoginNavigation()
                            }
                        }
                        
                        if let errorCode = dictionary["status_code"] as? Int{
                            let strErrorType = dictionary["error_type"] as? String ?? ""
                            _ = dictionary["message"] as? String ?? ""
                            if errorCode == 400{
                                
                                if strErrorType == "USER_NOT_FOUND" || strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                    //objAppShareData.showSessionFailAlert()
                                    return
                                    
                                }else{
                                    //  objAppShareData.showErrorAlert(strMessage:strMessage1)
                                }
                            }
                        }
                        success(parsedData as Dictionary<String, Any>)
                    }
                }catch{
                    print(response.description)
                }
            case .failure(let encodingError):
                print("PHP error",encodingError)
                failure(encodingError)
            }
        }
    }
    
    public func upload(image: Data, to url: Alamofire.URLRequestConvertible, params: [String: Any]) {
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(image, withName: "file", fileName: "file.png", mimeType: "image/png")
        }, with: url)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                //Do what ever you want to do with response
            })
    }
    
    
//    func myImageUploadRequest(strURL:String, imageToUpload: UIImage, imgKey: String, params : [String:String], completion: @escaping (Bool,Any,String) -> ())  {
//
//        let header: HTTPHeaders = ["authToken": strAuthToken ,
//                                   "Accept": "application/json",
//                                   "Content-Type": "application/x-www-form-urlencoded"]
//        print(header)
//        print(strURL)
//
//        let image = imageToUpload
//
//
//            AF.upload(multipartFormData: { multipartFormData in
//                            if let imageData = image.jpegData(compressionQuality: 1) {
//              multipartFormData.append(imageData, withName: "profile_pic", fileName: "fileNew.png", mimeType: "image/png")
//            }
//
//            for (key, value) in params {
//                multipartFormData.append((value.data(using: .utf8))!, withName: key)
//            }}, to: strURL, method: .post, headers: header,
//                encodingCompletion: { encodingResult in
//                  switch encodingResult {
//                  case .success(let upload, _, _):
//                    upload.response { [weak self] response in
//                      guard let strongSelf = self else {
//                        return
//                      }
//                       completion(true, response as Any, "")
//                      debugPrint(response)
//                    }
//                  case .failure(let encodingError):
//                    print("error:\(encodingError)")
//                    completion(false, encodingError as Any, "")
//                  }
//          })
//
//
//        }
        
    // //MARK: - upload MultipartData method with 3 images ---
    public func uploadMultipartWithImagesData(strURL:String, params : [String:Any]?,showIndicator:Bool , customValidation:String, imageData:Data?,imageToUpload:[Data],imagesParam:[String], fileName:String?, mimeType:String?, success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void){
        
        
        if !NetworkReachabilityManager()!.isReachable{
            let app = UIApplication.shared.delegate as? AppDelegate
            _ = app?.window
            //  objAlert.showAlertVc(title: k_noNetwork, controller: window!)
            //                DispatchQueue.main.async {
            //                    self.StopIndicator()
            //                }
            return
        }
        
        strAuthToken = ""
        if let token = UserDefaults.standard.string(forKey:UserDefaults.Keys.AuthToken) {
            
            strAuthToken =  token //"Bearer" + " " +
        }
        
        let header: HTTPHeaders = ["authToken": strAuthToken ,
                                   "Accept": "application/json",
                                   "Content-Type": "multipart/form-data"]
        print(header)
        print(strURL)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            let count = imageToUpload.count
            for i in 0..<count{
                multipartFormData.append(imageToUpload[i], withName: "\(imagesParam[i])", fileName: "file\(i).png" , mimeType: "image/png")
            }
            
            for (key, value) in params ?? [:]{
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, to: strURL,usingThreshold: UInt64.init(), method: .post,headers: header).response{ response in
            
            switch response.result{
            
            case .success( _):
                do {
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        
                        let dictionary = parsedData as NSDictionary
                        
                        if let errorCode = dictionary["status_code"] as? Int{
                            let strErrorType = dictionary["error_type"] as? String ?? ""
                            _ = dictionary["message"] as? String ?? ""
                            if errorCode == 400{
                                
                                if strErrorType == "USER_NOT_FOUND" || strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                    //objAppShareData.showSessionFailAlert()
                                    return
                                    
                                }else{
                                    //  objAppShareData.showErrorAlert(strMessage:strMessage1)
                                }
                            }
                        }
                        success(parsedData as Dictionary<String, Any>)
                    }
                }catch{
                    print(response.description)
                    // objAppShareData.showErrorAlert(strMessage:response.description)
                }
            case .failure(let encodingError):
                print("PHP error",encodingError)
                failure(encodingError)
            }
        }
    }
    ////
    public func requestPostOld(strURL:String, params : [String:Any], success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        
        if !(Connectivity.isConnectedToInternet){
            let app = UIApplication.shared.delegate as? AppDelegate
            _ = app?.window
            return
        }
        
        let _: HTTPHeaders = [
            "Authorization": "" ,
        ]
        AF.request(strURL, method: .post, parameters: params, encoding : URLEncoding.default, headers: nil).responseString { responseObject in
            print(responseObject)
            switch responseObject.result{
            
            case .success( _):
                
                do {
                    let dictionary = try JSONSerialization.jsonObject(with: responseObject.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    success(dictionary as! Dictionary<String, Any>)
                    print(dictionary)
                }catch{
                    
                }
            case .failure(let encodingError):
                print("PHP error",encodingError)
                failure(encodingError)
            }
        }
    }
    
    //MARK: - Request Patch method ----
    public func requestPatch(strURL:String, params : [String:Any]?,queryParams : [String:Any], strCustomValidation:String , success:@escaping(Dictionary<String,Any>) ->Void, failure:@escaping (Error) ->Void ) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            // objAppShareData.showNetworkAlert()
            return
        }
        
        strAuthToken = ""
        
        if let token = UserDefaults.standard.string(forKey: UserDefaults.Keys.AuthToken){
            strAuthToken = "Bearer" + " " + token
        }
        
        let currentTimeZone = getCurrentTimeZone()
        
        var strUdidi = ""
        if let MyUniqueId = UserDefaults.standard.string(forKey:UserDefaults.Keys.strVenderId) {
            print("defaults VenderID: \(MyUniqueId)")
            strUdidi = MyUniqueId
        }
        
        let headers: HTTPHeaders = [
            "Authorization": strAuthToken ,
            "Accept": "application/json",
            WsHeader.deviceId:strUdidi,
            WsHeader.deviceType:"1",
            WsHeader.deviceTimeZone: currentTimeZone
        ]
        
        var StrCompleteUrl = ""
        
        if strCustomValidation ==  WsParamsType.PathVariable{
            let pathvariable = queryParams.PathString
            StrCompleteUrl  = "\(strURL)"   + (pathvariable)
            print("pathvariablepathvariable.....\(pathvariable)")
            
        }
        else if  strCustomValidation ==  WsParamsType.QueryParams{
            StrCompleteUrl = self.queryString(strURL, params: queryParams ) ?? ""
        }
        else{
            StrCompleteUrl = strURL
        }
        
        print("url....\(StrCompleteUrl)")
        print("header....\(headers)")
        AF.request(StrCompleteUrl, method: .patch, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { responseObject in
            
            switch responseObject.result{
            
            case .success(let json):
                do {
                    let dictionary = json as! NSDictionary
                    
                    if let errorCode = dictionary["status_code"] as? Int{
                        let strErrorType = dictionary["error_type"] as? String ?? ""
                        _ = dictionary["message"] as? String ?? ""
                        if errorCode == 400{
                            
                            if strErrorType == "USER_NOT_FOUND" || strErrorType == "ACCOUNT_DISABLED" || strErrorType == "INVALID_TOKEN" || strErrorType == "SESSION_EXPIRED"{
                                // objAppShareData.showSessionFailAlert()
                                return
                                
                            }else{
                                //objAppShareData.showErrorAlert(strMessage:strMessage1)
                            }
                        }
                    }
                    success(dictionary as! Dictionary<String, Any>)
                }
            case .failure(let encodingError):
                print("PHP error",encodingError)
                failure(encodingError)
            }
        }
    }
}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output += "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
    
    var PathString: String {
        var output: String = ""
        for (_,value) in self {
            output += "\(value)"
        }
        output = String(output)
        return output
    }
}
