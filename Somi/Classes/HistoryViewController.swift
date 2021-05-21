//
//  HistoryViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit

class HistoryViewController: UIViewController {

    //MARK:- IBoutlets
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var vwGetReq: UIView!
    @IBOutlet weak var vwMyreq: UIView!
    @IBOutlet weak var lblGetReq: UILabel!
    @IBOutlet weak var lblMyReq: UILabel!
    @IBOutlet weak var vwHeaderBg: UIView!
    
    var userType = ""
    var arrMyRequests = [MyRequestsModel]()
    
    //MARK:- App Lyf Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblHistory.delegate = self
        self.tblHistory.dataSource = self
        
        self.lblGetReq.textColor = UIColor.white
      
        self.vwGetReq.layer.cornerRadius = 5
        
        self.lblMyReq.textColor = UIColor.black
        self.vwMyreq.layer.backgroundColor = UIColor.white.cgColor
        self.vwMyreq.layer.borderWidth = 1.0
        
        self.vwMyreq.layer.cornerRadius = 5
        
//        self.userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
//        self.setStyling(strUserType: userType)
        
        self.call_WsGetMyrequest(strUserID: objAppShareData.UserDetail.strUserId)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        self.userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
            self.vwGetReq.layer.backgroundColor = UIColor.init(named: "appBlueColor")?.cgColor
            self.vwMyreq.layer.borderColor = UIColor.init(named: "appBlueColor")?.cgColor
            
        }else{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
            self.vwGetReq.layer.backgroundColor = UIColor.init(named: "appPinkColor")?.cgColor
            self.vwMyreq.layer.borderColor = UIColor.init(named: "appPinkColor")?.cgColor
        }
    }
    

    //MARK:- IBAction
    @IBAction func actionBtnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionBtnGetRequest(_ sender: Any) {
        self.lblGetReq.textColor = UIColor.white
        self.vwGetReq.layer.backgroundColor = UIColor.init(named: "appBlueColor")?.cgColor
        
        self.lblMyReq.textColor = UIColor.black
        self.vwMyreq.layer.backgroundColor = UIColor.white.cgColor
        self.vwMyreq.layer.borderWidth = 1.0
        self.vwMyreq.layer.borderColor = UIColor.init(named: "appBlueColor")?.cgColor
        self.vwMyreq.layer.cornerRadius = 5
        
        if self.userType == "Male"{
            self.vwGetReq.layer.backgroundColor = UIColor.init(named: "appBlueColor")?.cgColor
            self.vwMyreq.layer.borderColor = UIColor.init(named: "appBlueColor")?.cgColor
        }else{
            self.vwGetReq.layer.backgroundColor = UIColor.init(named: "appPinkColor")?.cgColor
            self.vwMyreq.layer.borderColor = UIColor.init(named: "appPinkColor")?.cgColor
        }
        
    }
    
    @IBAction func actionBtnMyRequest(_ sender: Any) {
        self.lblMyReq.textColor = UIColor.white
        if self.userType == "Male"{
            self.vwMyreq.layer.backgroundColor = UIColor.init(named: "appBlueColor")?.cgColor
            self.vwGetReq.layer.borderColor = UIColor.init(named: "appBlueColor")?.cgColor
        }else{
            self.vwMyreq.layer.backgroundColor = UIColor.init(named: "appPinkColor")?.cgColor
            self.vwGetReq.layer.borderColor = UIColor.init(named: "appPinkColor")?.cgColor
        }
        
        
        self.lblGetReq.textColor = UIColor.black
        self.vwGetReq.layer.backgroundColor = UIColor.white.cgColor
        self.vwGetReq.layer.borderWidth = 1.0
        
        self.vwGetReq.layer.cornerRadius = 5
        
        
    }
}

//MARK:- UITableView Delgates and Datasource
extension HistoryViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMyRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell")as? HistoryTableViewCell{
            
            let obj = self.arrMyRequests[indexPath.row]
            
            cell.lblAddress.text = obj.strUserAddress
            cell.btnRequest.setTitle(obj.strCategoryName, for: .normal)
            cell.lblTime.text = obj.strDateTime
            
            let profilePic = obj.strCategoryImage
            
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
}

//MARK:- Call Webservice
extension HistoryViewController{
    func call_WsGetMyrequest(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let dicrParam = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetMyRequest, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for dictData in arrData{
                     
                        let obj = MyRequestsModel.init(dict: dictData)
                        self.arrMyRequests.append(obj)
                        
                    }
                    self.tblHistory.reloadData()
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
