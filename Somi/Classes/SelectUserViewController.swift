//
//  SelectUserViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/05/21.
//

import UIKit

class SelectUserViewController: UIViewController {

    @IBOutlet var tblVw: UITableView!
    @IBOutlet var vwHeaderBg: UIView!
    
    var userType = ""
    var strReqType = ""
    var lat = ""
    var long = ""
    var arrUsers = [GetContactsModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        // Do any additional setup after loading the view.
        
        self.call_WsGetContactList(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
    }
    
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
        }else{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


//MARK:- UITAbleVie Datasaource and Delagete
extension SelectUserViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell")as! ContactsTableViewCell
        
        let obj = self.arrUsers[indexPath.row]
        
        cell.lblUserName.text = obj.strName
        cell.lblPhoneNumber.text = obj.strMobile
        
        //Set Contact Image
        let profilePic = obj.strUserImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }else{
            cell.imgVwUser.image = #imageLiteral(resourceName: "app_logo")
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrUsers[indexPath.row]

        let urlString = "Please Help me My Request is \(strReqType) and my location is latitude:\(self.lat)&longitude:\(self.long)"
        let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        self.openWhatsApp(strPhoneNumber: obj.strMobile, strMessage: urlStringEncoded)
        
        
    }
    
    func openWhatsApp(strPhoneNumber:String, strMessage:String){
        let phoneNumber =  strPhoneNumber // you need to change this number
        let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)&text=\(strMessage)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            let appURLL = URL(string: "https://wa.me/\(strPhoneNumber)")!
            if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURLL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURLL)
                }
        }
    }
    
    
}


extension SelectUserViewController{
    
    func call_WsGetContactList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        
        let dicrParam = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetMyContact, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for dictData in arrData{
                        let obj = GetContactsModel.init(dict: dictData)
                        self.arrUsers.append(obj)
                    }

                    if self.arrUsers.count == 0{
                        self.tblVw.displayBackgroundText(text: "No Record Found")
                    }else{
                        self.tblVw.displayBackgroundText(text: "")
                    }
                    
                    self.tblVw.reloadData()
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
