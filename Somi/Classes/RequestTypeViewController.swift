//
//  RequestTypeViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 23/03/21.
//

import UIKit
import SDWebImage

class RequestTypeViewController: UIViewController {

    @IBOutlet weak var cvRequestType: UICollectionView!
    @IBOutlet weak var vwHeaderBg: UIView!
    @IBOutlet weak var vwBtnBg: UIView!
    
    var strLatitude = ""
    var strLongitude = ""
    var strAddress = ""
    var strSelectedCategoryID = ""
    
    var arrData = [GetCategories]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cvRequestType.delegate = self
        self.cvRequestType.dataSource = self
        
        // Do any additional setup after loading the view.
        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        
        self.call_WsGetCategories()
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
            
        }else{
            self.vwHeaderBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.vwBtnBg.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }

    @IBAction func actionBtnSend(_ sender: Any) {
        self.call_WsSendRequest(strCategoryID: strSelectedCategoryID)
        
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension RequestTypeViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RequestTypeCollectionViewCell", for: indexPath)as? RequestTypeCollectionViewCell{
            
            let obj = self.arrData[indexPath.row]
            
            cell.lblCategory.text = obj.strCategoryName
            
            let profilePic = obj.strCategoryImage
            
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgVwCategory.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.arrData[indexPath.row]
        self.strSelectedCategoryID = obj.strCategoryID
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size + 10)
    }
    /*
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
 

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
     */
}


//MARK:- Call Webservice
extension RequestTypeViewController{
    
    func call_WsGetCategories(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        
    
        objWebServiceManager.requestGet(strURL: WsUrl.url_GetCategories, params: [:], queryParams: [:], strCustomValidation: "") { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                if let arrData  = response["result"] as? [[String:Any]]{
                    
                    for dictData in arrData{
                     
                        let obj = GetCategories.init(dict: dictData)
                        self.arrData.append(obj)
                        
                    }
                    
                    self.cvRequestType.reloadData()
                    
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
    
    
    func call_WsSendRequest(strCategoryID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
    
        objWebServiceManager.showIndicator()
        
        let userID = objAppShareData.UserDetail.strUserId
        
        let dicrParam = ["user_id":userID,
                         "lat":self.strLatitude,
                         "lng":self.strLongitude,
                         "address":self.strAddress,
                         "category_id":strCategoryID]as [String:Any]
        
    
        objWebServiceManager.requestPost(strURL: WsUrl.url_SendRequest, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                objAlert.showAlertCallBack(alertLeftBtn: "", alertRightBtn: "OK", title: "Success", message: "Your Request has been sent succesfully.", controller: self) {
                    self.navigationController?.popViewController(animated: true)
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



