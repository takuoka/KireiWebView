//
//  KireiWebViewController+Util.swift
//  KireiWebView
//
//  Created by Takuya Okamoto on 2015/07/09.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit


extension KireiWebViewController {

    func changeUserAgentAsPC(){
        let userAgentStr = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.63 Safari/537.36"
        let dic:NSDictionary = ["UserAgent":userAgentStr]
        UserDefaults.standard.register(defaults: dic as! [String : AnyObject])
    }
    
    func imageNamed(_ name:String) -> UIImage? {
        return UIImage(named: name, in: Bundle(for: KireiWebViewController.self), compatibleWith: nil)
    }
    
    func hirakakuFont(_ size: CGFloat) -> UIFont {
        return UIFont(name: "HiraKakuProN-W3", size: size)!
    }
    
    func openActivityView(_ completion:(()->())?) {
        print("openActivityView")
        var items:[AnyObject] = []
        if webview.title != nil {
            items.append(webview.title! as AnyObject)
        }
        if webview.url != nil {
            items.append(webview.url! as AnyObject)
        }
        
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        activityVC.completionWithItemsHandler = { hander in
            if (hander.1) {
                completion?()
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }

    func openSafari(_ url: URL?) {
        if url != nil {
            if UIApplication.shared.canOpenURL(url!){
                UIApplication.shared.openURL(url!)
            }
        }
    }
}
