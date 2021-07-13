//
//  SignUpViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit
import Alamofire
import SystemConfiguration

class SignUpViewController: UIViewController, UINavigationControllerDelegate {

    //MARK:- IBOutlets
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var imgVwMale: UIImageView!
    @IBOutlet weak var imgVeFemale: UIImageView!
    @IBOutlet weak var vwSignUpBg: UIView!
    @IBOutlet weak var tfEnterBloodGroup: UITextField!
    @IBOutlet weak var tfEnterAllergy: UITextField!
    @IBOutlet weak var tfEmergencyNumber: UITextField!
    
    //MARK:- Variables
    var imagePicker = UIImagePickerController()
    var pickedImage:UIImage?
    var userType = "Male"
    
    //MARK:- App Lyf Cycyle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tfUserName.delegate = self
        self.tfEmail.delegate = self
        self.tfPassword.delegate = self
        self.tfPhoneNumber.delegate = self
        self.tfEnterBloodGroup.delegate = self
        self.tfEnterAllergy.delegate = self
        self.tfEmergencyNumber.delegate = self
        self.imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    //MARK:- Button Actions
    @IBAction func actionBtnMale(_ sender: Any) {
        
        self.imgVwMale.image = #imageLiteral(resourceName: "blue")
        self.imgVeFemale.image = #imageLiteral(resourceName: "pink")
        self.userType = "Male"
        UserDefaults.standard.setValue("Male", forKey: UserDefaults.Keys.userType)
        self.vwSignUpBg.backgroundColor = UIColor.init(named: "appBlueColor")
        
    }

    @IBAction func actionBtnFemale(_ sender: Any) {
        self.imgVwMale.image = #imageLiteral(resourceName: "uncheck")
        self.imgVeFemale.image = #imageLiteral(resourceName: "check")
        self.userType = "Female"
        UserDefaults.standard.setValue("Female", forKey: UserDefaults.Keys.userType)
        self.vwSignUpBg.backgroundColor = UIColor.init(named: "appPinkColor")
    }
    
    @IBAction func actionBtnOpenCamera(_ sender: Any) {
        self.setImage()
        
    }
    @IBAction func actionbtnLogin(_ sender: Any) {
        self.view.endEditing(true)
        
        self.validateForSignUp()

        
    }
    @IBAction func actionBtnGOBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
   
    
    //MARK:- All Validations
    func validateForSignUp(){
        self.tfUserName.text = self.tfUserName.text!.trim()
        self.tfEmail.text = self.tfEmail.text!.trim()
        self.tfEnterBloodGroup.text = self.tfEnterBloodGroup.text!.trim()
        self.tfEnterAllergy.text = self.tfEnterAllergy.text!.trim()
        self.tfPhoneNumber.text = self.tfPhoneNumber.text!.trim()
        self.tfPassword.text = self.tfPassword.text!.trim()
        //
        if (tfUserName.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankUserName, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfEmail.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }else if !objValidationManager.validateEmail(with: tfEmail.text!){
            objAlert.showAlert(message: MessageConstant.ValidEmail, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else  if (tfPhoneNumber.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPhoneNo, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfPassword.text?.isEmpty)! {
            objAlert.showAlert(message: MessageConstant.BlankPassword, title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfEnterBloodGroup.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter blood group", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfEnterAllergy.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter allergy", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else if (tfEmergencyNumber.text?.isEmpty)! {
            objAlert.showAlert(message: "Please enter emergency number", title:MessageConstant.k_AlertTitle, controller: self)
        }
        else{
           self.callWebserviceForUploadUserImage()
           // self.myImageUploadRequest()
        }
    }
    

}

//MARK:- UITextFiled Delegates
extension SignUpViewController : UITextFieldDelegate{
    // TextField delegate method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfUserName{
            self.tfEmail.becomeFirstResponder()
            self.tfUserName.resignFirstResponder()
        }
        else if textField == self.tfEmail{
            self.tfPhoneNumber.becomeFirstResponder()
            self.tfEmail.resignFirstResponder()
        }
        else if textField == self.tfPhoneNumber{
            self.tfPassword.becomeFirstResponder()
            self.tfPhoneNumber.resignFirstResponder()
        }
        else if textField == self.tfPassword{
            self.tfEnterBloodGroup.becomeFirstResponder()
            self.tfPassword.resignFirstResponder()
           
        }
        else if textField == self.tfEnterBloodGroup{
            self.tfEnterAllergy.becomeFirstResponder()
            self.tfEnterBloodGroup.resignFirstResponder()
           
        } else if textField == self.tfEnterAllergy{
            self.tfEnterAllergy.resignFirstResponder()
           
        }
        return true
    }
}


extension SignUpViewController: UIImagePickerControllerDelegate{
    
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

//MARK:- CallWebservice
extension SignUpViewController{
    
    func callWebserviceForUploadUserImage(){
        
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
        
        print(imageData)
        
        let dicrParam = ["name":self.tfUserName.text!,
                         "email":self.tfEmail.text!,
                         "mobile":self.tfPhoneNumber.text!,
                         "password":self.tfPassword.text!,
                         "type":"user",
                         "blood_group":self.tfEnterBloodGroup.text!,
                         "allergy":self.tfEnterAllergy.text!,
                         "emergency_number":self.tfEmergencyNumber.text!,
                         "sex":self.userType,
                         "ios_register_id":objAppShareData.strFirebaseToken]as [String:Any]
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_SignUp, params: dicrParam, showIndicator: true, customValidation: "", imageData: imageData, imageToUpload: [], imagesParam: [], fileName: "user_image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
            
                let user_details  = response["result"] as? [String:Any]

                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                objAppShareData.fetchUserInfoFromAppshareData()

                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddContactsViewController")as! AddContactsViewController
                self.navigationController?.pushViewController(vc, animated: true)

            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
    
    

    
   }

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

