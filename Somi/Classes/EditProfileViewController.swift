//
//  EditProfileViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit
import Alamofire

class EditProfileViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var vwBtnBg: UIView!
    @IBOutlet weak var VwHeaderBg: UIView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfBloodGroup: UITextField!
    @IBOutlet weak var tfAllergy: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet var btnMale: UIButton!
    @IBOutlet var btnFemale: UIButton!
    @IBOutlet var imgVwMale: UIImageView!
    @IBOutlet var imgVwFemale: UIImageView!
    @IBOutlet var imgVwEditProfile: UIImageView!
    @IBOutlet var tfEmergencyNumber: UITextField!
    
    //MARK:- Variables
    var dictUserData = [String:Any]()
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var strUserType = ""
    
    //MARK:- App Lyf Cycle
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
        self.tfEmergencyNumber.text = (dictUserData["emergency_number"] as! String)
        
        if let profilePic = dictUserData["user_image"] as? String{
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img"))
            }
        }
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.VwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
            self.imgVwEditProfile.image = #imageLiteral(resourceName: "edit_profile_icon")
            self.imgVwMale.image = #imageLiteral(resourceName: "blue")
            self.imgVwFemale.image = #imageLiteral(resourceName: "pink")
        }else{
            self.VwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
            self.imgVwEditProfile.image = #imageLiteral(resourceName: "edit_pink")
            self.imgVwMale.image = #imageLiteral(resourceName: "uncheck")
            self.imgVwFemale.image = #imageLiteral(resourceName: "check")
        }
    }
    
    //MARK:- IBAction
    @IBAction func btnMale(_ sender: Any) {
        self.imgVwMale.image = #imageLiteral(resourceName: "blue")
        self.imgVwFemale.image = #imageLiteral(resourceName: "pink")
        self.strUserType = "Male"
        self.imgVwEditProfile.image = #imageLiteral(resourceName: "edit_profile_icon")
        
        self.VwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
        self.vwBtnBg.backgroundColor = UIColor.init(named: "appBlueColor")
        self.view.backgroundColor = UIColor.init(named: "appBlueColor")
        
    }
    @IBAction func btnFemale(_ sender: Any) {
        self.imgVwMale.image = #imageLiteral(resourceName: "uncheck")
        self.imgVwFemale.image = #imageLiteral(resourceName: "check")
        self.strUserType = "Female"
       
        self.imgVwEditProfile.image = #imageLiteral(resourceName: "edit_pink")
        self.VwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
        self.vwBtnBg.backgroundColor = UIColor.init(named: "appPinkColor")
        self.view.backgroundColor = UIColor.init(named: "appPinkColor")
    }
    
    
    @IBAction func btnOpencamera(_ sender: Any) {
        self.setImage()
    }
    
    @IBAction func actionBtnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func actionBtnSave(_ sender: Any) {
        self.validateForSignUp()
        
    }
}

//MARK:- UItextField Delegates and Datasorce
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
    
    
    //MARK:- All Validations
    func validateForSignUp(){
        self.tfPhoneNumber.text = self.tfPhoneNumber.text!.trim()
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfBloodGroup.text = self.tfBloodGroup.text!.trim()
        self.tfAllergy.text = self.tfAllergy.text!.trim()
        self.tfPhoneNumber.text = self.tfPhoneNumber.text!.trim()
        self.tfAddress.text = self.tfAddress.text!.trim()
        //
         if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else  if (tfPhoneNumber.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPhoneNo, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfBloodGroup.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter blood group", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfAllergy.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter Allergy", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfAddress.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter address", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else{
            self.callWebserviceUpdateProfile()
        }
    }
}

//MARK:- UIImagePicker
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

//MARK:- Upload Image Functions
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
    
    
    //MARK:- Call WebService Upload Profile
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
                         "user_id":objAppShareData.UserDetail.strUserId,
                         "emergency_number":self.tfEmergencyNumber.text!,
                         "sex":self.strUserType]as [String:Any]
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_completeProfile, params: dicrParam, showIndicator: true, customValidation: "", imageData: imageData, imageToUpload: [], imagesParam: [], fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]
                if user_details?["sex"] as! String == "Male"{
                    UserDefaults.standard.setValue("Male", forKey: UserDefaults.Keys.userType)
                }else{
                    UserDefaults.standard.setValue("Female", forKey: UserDefaults.Keys.userType)
                }
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
