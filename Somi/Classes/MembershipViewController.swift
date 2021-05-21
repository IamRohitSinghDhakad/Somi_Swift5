//
//  MembershipViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 15/05/21.
//

import UIKit

class MembershipViewController: UIViewController {

    @IBOutlet var lblMemberShip: UILabel!
    @IBOutlet var vwSilverPlanContainer: UIView!
    @IBOutlet var lblTextSilverPlan: UILabel!
    @IBOutlet var lblSilverPlanAmount: UILabel!
    @IBOutlet var vwGoldPlanContainer: UIView!
    @IBOutlet var lblTextGoldPlan: UILabel!
    @IBOutlet var lblAmountGoldPlan: UILabel!
    @IBOutlet var lblTextPlatinumPlan: UILabel!
    @IBOutlet var vwPlatinumContainer: UIView!
    @IBOutlet var lblAmountPlatinumplan: UILabel!
    @IBOutlet var vwContainerTop: UIView!
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblCurrentPlan: UILabel!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var vwBgBtn: UIView!
    
    var arrPlans = [MemberShipModel]()
    var strSelectedPlanID = ""
    var strUserType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwContainerTop.dropShadowWithCorner(cornerRadius: 2, borderWidth: 0.2, borderColor: UIColor.lightGray)
        self.imgVwUser.makeCircleImage()
        
        self.call_GetPlans(strUserID: objAppShareData.UserDetail.strUserId)
        self.call_GetProfile(strUserID: objAppShareData.UserDetail.strUserId)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        let profileUrl = objAppShareData.UserDetail.strProfilePicture
            if profileUrl != "" {
                let url = URL(string: profileUrl)
                self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "app_logo"))
            }
        
        self.strUserType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: self.strUserType)
        
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwHeader.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
            self.vwSilverPlanContainer.addViewBorder(borderColor: UIColor.init(named: "appBlueColor")!, borderWith: 1, borderCornerRadius: 2)
            self.vwGoldPlanContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            self.vwPlatinumContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            
            self.vwBgBtn.backgroundColor = UIColor.init(named: "appBlueColor")
        }else{
            self.vwHeader.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
            self.vwSilverPlanContainer.addViewBorder(borderColor: UIColor.init(named: "appPinkColor")!, borderWith: 1, borderCornerRadius: 2)
            self.vwGoldPlanContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            self.vwPlatinumContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            
            self.vwBgBtn.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }
    
    @IBAction func btnOnSilverPlan(_ sender: Any) {
        
        if self.strUserType == "Male"{
            self.vwSilverPlanContainer.addViewBorder(borderColor: UIColor.init(named: "appBlueColor")!, borderWith: 1, borderCornerRadius: 2)
            self.vwGoldPlanContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            self.vwPlatinumContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            
        }else{
            self.vwSilverPlanContainer.addViewBorder(borderColor: UIColor.init(named: "appPinkColor")!, borderWith: 1, borderCornerRadius: 2)
            self.vwGoldPlanContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            self.vwPlatinumContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
        }
        
        
        let planID = self.arrPlans[2].strPlanID
        self.strSelectedPlanID = planID
    }
    
    @IBAction func btnOnGoldPlan(_ sender: Any) {
        
        if self.strUserType == "Male"{
            self.vwGoldPlanContainer.addViewBorder(borderColor: UIColor.init(named: "appBlueColor")!, borderWith: 1, borderCornerRadius: 2)
            self.vwSilverPlanContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            self.vwPlatinumContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            
        }else{
            self.vwGoldPlanContainer.addViewBorder(borderColor: UIColor.init(named: "appPinkColor")!, borderWith: 1, borderCornerRadius: 2)
            self.vwSilverPlanContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            self.vwPlatinumContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
        }
        
        let planID = self.arrPlans[0].strPlanID
        self.strSelectedPlanID = planID
    }
    @IBAction func btnOnPlatinumPlan(_ sender: Any) {
        if self.strUserType == "Male"{
            self.vwPlatinumContainer.addViewBorder(borderColor: UIColor.init(named: "appBlueColor")!, borderWith: 1, borderCornerRadius: 2)
            self.vwSilverPlanContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            self.vwGoldPlanContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            
        }else{
            self.vwPlatinumContainer.addViewBorder(borderColor: UIColor.init(named: "appPinkColor")!, borderWith: 1, borderCornerRadius: 2)
            self.vwSilverPlanContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
            self.vwGoldPlanContainer.addViewBorder(borderColor: UIColor.lightGray, borderWith: 0.5, borderCornerRadius: 2)
        }
        
        
        let planID = self.arrPlans[1].strPlanID
        self.strSelectedPlanID = planID
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOnSubscribe(_ sender: Any) {
        
        let userID = objAppShareData.UserDetail.strUserId
       if userID != ""{
        self.call_SubscribePlan(strUserID: userID, strPlanID: self.strSelectedPlanID)
       }
    }
}


extension UIView {
    public func addViewBorder(borderColor:UIColor,borderWith:CGFloat,borderCornerRadius:CGFloat){
        self.layer.borderWidth = borderWith
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = borderCornerRadius

    }
    
    func dropShadowWithCorner(cornerRadius:CGFloat, borderWidth:CGFloat, borderColor:UIColor){
        // corner radius
        self.layer.cornerRadius = cornerRadius

        // border
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor

        // shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
    }
}


extension MembershipViewController{
    
    func call_GetPlans(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        let dicrParam = ["user_id":strUserID]as [String:Any]
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetPlans, params: dicrParam, queryParams: [:], strCustomValidation: "") { (response) in
            
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
           
            if status == MessageConstant.k_StatusCode{
                
                if  let user_details  = response["result"] as? [[String:Any]] {
                    
                    for data in user_details{
                        
                        let obj = MemberShipModel.init(dict: data)
                        self.arrPlans.append(obj)
                        
                    }
                    if self.arrPlans.count > 2{
                        self.setData()
                    }
                    
                }
                
            }else{
                objAlert.showAlert(message: message!, title: "Alert", controller: self)
            }
            
            
        } failure: { (Error) in
            print(Error)
            
            objWebServiceManager.hideIndicator()
        }
   }
    
    
    func call_SubscribePlan(strUserID:String, strPlanID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
    
        let dicrParam = ["user_id":strUserID,
                         "plan_id":strPlanID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_SubscribePlan, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
           
            if status == MessageConstant.k_StatusCode{
                
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Alert", message: "Purchased Succesfully", controller: self) {
                    self.call_GetProfile(strUserID: objAppShareData.UserDetail.strUserId)
                    //self.navigationController?.popViewController(animated: true)
                }
                print(response)
                
            }else{
                objAlert.showAlert(message: message!, title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
            
            objWebServiceManager.hideIndicator()
        }
   }
    
    
    func setData(){
        //Set By default First plan
        let planID = self.arrPlans[2].strPlanID
        self.strSelectedPlanID = planID
        
        let planDaysGold = self.arrPlans[0].strPlanTitle
        let planDaysPlatinum = self.arrPlans[1].strPlanTitle
        let planDaysSilver = self.arrPlans[2].strPlanTitle
        
        let plansGold = self.arrPlans[0].strValidity
        let plansPlatinum = self.arrPlans[1].strValidity
        let plansSilver = self.arrPlans[2].strValidity
        
    
        self.lblTextGoldPlan.text = "\(planDaysGold) Plan\n" + "\(plansGold) Days"
        self.lblTextPlatinumPlan.text = "\(planDaysPlatinum) Plan\n" + "\(plansPlatinum) Days"
        self.lblTextSilverPlan.text = "\(planDaysSilver) Plan\n" + "\(plansSilver) Days"
        
        let goldPrice = self.arrPlans[0].strPrice
        let platinumPrice = self.arrPlans[1].strPrice
        let silverPrice = self.arrPlans[2].strPrice
        
        self.lblAmountGoldPlan.text = "$\(goldPrice)"
        self.lblAmountPlatinumplan.text = "$\(platinumPrice)"
        self.lblSilverPlanAmount.text = "$\(silverPrice)"

    }
    
    
    func call_GetProfile(strUserID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
       
        
        let dicrParam = ["user_id":strUserID]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
           
            if status == MessageConstant.k_StatusCode{
                
                if  let user_details  = response["result"] as? [String:Any] {
                    print(user_details)
                   if let dictPlan = user_details["plan"] as? [String:Any]{
                        self.lblCurrentPlan.text = dictPlan["plan_title"] as? String ?? "N/A"
                    }
                }
                
            }else{
                objAlert.showAlert(message: message!, title: "Alert", controller: self)
            }
            
            
        } failure: { (Error) in
            print(Error)
            
            objWebServiceManager.hideIndicator()
        }

    
   }
    
}
