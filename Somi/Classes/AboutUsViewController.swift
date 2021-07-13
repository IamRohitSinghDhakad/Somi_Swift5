//
//  AboutUsViewController.swift
//  Somi
//
//  Created by Rohit Singh Dhakad on 13/05/21.
//

import UIKit
import WebKit

class AboutUsViewController: UIViewController {
    
    @IBOutlet var webVw: WKWebView!
    @IBOutlet var vwHeader: UIView!
    
    
    func loadUrl(strUrl:String){
        let url = NSURL(string: strUrl)
        let request = NSURLRequest(url: url! as URL)
        webVw.load(request as URLRequest)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        let userType = UserDefaults.standard.value(forKey: UserDefaults.Keys.userType)as? String ?? "Male"
        self.setStyling(strUserType: userType)
        
    }
    
    func setStyling(strUserType:String){
        if strUserType == "Male"{
            self.vwHeader.backgroundColor = UIColor.init(named: "appBlueColor")
            self.view.backgroundColor = UIColor.init(named: "appBlueColor")
        }else{
            self.vwHeader.backgroundColor = UIColor.init(named: "appPinkColor")
            self.view.backgroundColor = UIColor.init(named: "appPinkColor")
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadUrl(strUrl: "http://ambitious.in.net/Arun/Somi/index.php/api/page/About%20Us")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackOnHeader(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AboutUsViewController: WKNavigationDelegate{
        
        private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
            print(error.localizedDescription)
        }
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Strat to load")
        }
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("finish to load")
        }
}
