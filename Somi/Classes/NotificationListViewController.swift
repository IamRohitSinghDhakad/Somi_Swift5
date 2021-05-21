//
//  NotificationListViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 02/05/21.
//

import UIKit

class NotificationListViewController: UIViewController {
    @IBOutlet var tblVw: UITableView!
    
    
    var arrNotificationList = [NotificationListModel]()
    
   // let userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
       let userID  = objAppShareData.UserDetail.strUserId
       if userID != ""{
           self.call_WSNotificationList(strUserID: userID)
       }

        // Do any additional setup after loading the view.
    }
    
    
    

    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension NotificationListViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell")as! NotificationTableViewCell
        
        let obj = self.arrNotificationList[indexPath.row]
        
        cell.lblName.text = obj.strName
        cell.lblTimeAgo.text = obj.strTimeAgo
        cell.lblTitle.text = obj.strNotificationTitle
        
        
        let profilePic = obj.userImage
        
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = self.arrNotificationList[indexPath.row]
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController")as! NotificationViewController
        vc.strReqID = obj.strRequestID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
}

//MARK:- Call WebService
extension NotificationListViewController{
    
    func call_WSNotificationList(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":strUserID,
                        ]as [String:Any]
        
        objWebServiceManager.requestGet(strURL: WsUrl.url_NotificationList, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for dictData in arrData{
                        let obj = NotificationListModel.init(dict: dictData)
                        self.arrNotificationList.append(obj)
                    }
                    self.tblVw.reloadData()
                   
                }
                
                if self.arrNotificationList.count == 0{
                    objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Alert", message:"No Record Found", controller: self) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Alert", message:"No Record Found", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }
               // objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
           
        } failure: { (Error) in
            print(Error)
            objWebServiceManager.hideIndicator()
        }
   }
    
}
