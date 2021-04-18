//
//  EditProfileViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit
import Alamofire

class EditProfileViewController: UIViewController {

    @IBOutlet weak var vwBtnBg: UIView!
    @IBOutlet weak var VwHeaderBg: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfBloodGroup: UITextField!
    @IBOutlet weak var tfAllergy: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    
    var dictUserData = [String:Any]()
    
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker.delegate = self
        
        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUserData()
    }
    
    func setUserData(){
        self.tfEmail.text = (dictUserData["email"] as! String)
        self.tfPhoneNumber.text  = (dictUserData["mobile"] as! String)
        self.tfBloodGroup.text = (dictUserData["blood"] as! String)
        self.tfAllergy.text = (dictUserData["allergy"] as! String)
        self.tfAddress.text = (dictUserData["address"] as! String)
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.VwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
        }else{
            self.VwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }
    @IBAction func btnOpencamera(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func actionBtnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func actionBtnSave(_ sender: Any) {
        
        
        var imageData : Data?
        if self.pickedImage != nil{
            imageData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
        }
        
        let dicrParam = ["email":self.tfEmail.text!,
                         "mobile":self.tfPhoneNumber.text!,
                         "type":"user",
                         "blood_group":self.tfBloodGroup.text!,
                         "allergy":self.tfAllergy.text!,
                         "address":self.tfAddress.text!,
                         "user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        
        print(imageData, dicrParam, WsUrl.url_completeProfile)
        
        self.uploadImage(endUrl: WsUrl.url_completeProfile, imageData: imageData, parameters: dicrParam)
        
       // self.callWebserviceUpdateProfile()
    }
    
}

extension EditProfileViewController : UITextFieldDelegate{
    // TextField delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfEmail{
            self.tfPhoneNumber.becomeFirstResponder()
            self.tfEmail.resignFirstResponder()
        }
        else if textField == self.tfPhoneNumber{
            self.tfBloodGroup.becomeFirstResponder()
            self.tfPhoneNumber.resignFirstResponder()
        }
        else if textField == self.tfBloodGroup{
            self.tfAllergy.becomeFirstResponder()
            self.tfBloodGroup.resignFirstResponder()
        }
        else if textField == self.tfAllergy{
            self.tfAddress.becomeFirstResponder()
            self.tfAllergy.resignFirstResponder()
           
        }
        else if textField == self.tfAddress{
            self.tfAddress.resignFirstResponder()
           
        }
        return true
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // MARK:- UIImage Picker Delegate
    func setImage(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.view
        self.present(alert, animated: true, completion: nil)
    }
    
    // Open camera
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = .fullScreen
            self .present(imagePicker, animated: true, completion: nil)
        } else {
            self.openGallery()
        }
    }
    
    // Open gallery
    func openGallery()
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            self.pickedImage = editedImage
            self.imgVwUser.image = self.pickedImage
            //  self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            
            self.makeRounded()
            if self.imgVwUser.image == nil{
                // self.viewEditProfileImage.isHidden = true
            }else{
                // self.viewEditProfileImage.isHidden = false
            }
            imagePicker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.pickedImage = originalImage
            self.imgVwUser.image = pickedImage
            self.makeRounded()
            // self.cornerImage(image: self.imgUpload,color:#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) ,width: 0.5 )
            if self.imgVwUser.image == nil{
                // self.viewEditProfileImage.isHidden = true
            }else{
                //self.viewEditProfileImage.isHidden = false
            }
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    func cornerImage(image: UIImageView, color: UIColor ,width: CGFloat){
        image.layer.cornerRadius = image.layer.frame.size.height / 2
        image.layer.masksToBounds = false
        image.layer.borderColor = color.cgColor
        image.layer.borderWidth = width
        
    }
    
    func makeRounded() {
        
        self.imgVwUser.layer.borderWidth = 0
        self.imgVwUser.layer.masksToBounds = false
        //self.imgUpload.layer.borderColor = UIColor.blackColor().CGColor
        self.imgVwUser.layer.cornerRadius = self.imgVwUser.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        self.imgVwUser.clipsToBounds = true
    }
    
}


extension EditProfileViewController{
    
    
    
    func uploadImage(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((_ isSuccess:Bool) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
       
        
        let header: HTTPHeaders = ["authToken": strAuthToken ,
                                   "Accept": "application/json",
                                   "Content-Type": "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            
            for (key, value) in parameters {
                if let temp = value as? String {
                    multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "file", fileName: "user_image", mimeType: "image/png")
            }
        },
                  to: endUrl, method: .post , headers: header)
            .responseJSON(completionHandler: { (response) in
                
                print(response)
                
                if let err = response.error{
                    print(err)
                    onError?(err)
                    return
                }
                print("Succesfully uploaded")
                
                let json = response.data
                
                if (json != nil)
                {
                  //  let jsonObject = JSON(json!)
                    print(json)
                }
            })
      }
    
    func callWebserviceUpdateProfile(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        var imageData : Data?
        if self.pickedImage != nil{
            imageData = (self.pickedImage?.jpegData(compressionQuality: 1.0))!
        }
        
        let dicrParam = ["email":self.tfEmail.text!,
                         "mobile":self.tfPhoneNumber.text!,
                         "type":"user",
                         "blood_group":self.tfBloodGroup.text!,
                         "allergy":self.tfAllergy.text!,
                         "address":self.tfAddress.text!,
                         "user_id":objAppShareData.UserDetail.strUserId]as [String:Any]
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_completeProfile, params: dicrParam, showIndicator: true, customValidation: "", imageData: imageData, imageToUpload: [], imagesParam: [], fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()
                
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Success", message: "Your Profile Updated.", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }

            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
}
