//
//  ViewController.swift
//  Sample
//
//  Created by Takuya Okamoto on 2015/09/24.
//  Copyright © 2015年 Uniface. All rights reserved.
//

import UIKit
import KireiWebView

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testView = UIButton()
        testView.frame = CGRect(x: 0, y: 0, width: 88, height: 88)
        testView.center = self.view.center
        testView.setTitle("open", forState: .Normal)
        testView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.view.addSubview(testView)
        testView.addTarget(self, action: #selector(ViewController.didTapButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        NSTimer.schedule(delay: 0.4) { timer in
            self.didTapButton()
        }
    }
    
    func didTapButton() {
        let url = "http://raw.senmanga.com/release"
        let kireiWebView = KireiWebViewController(url: url)
        //        kireiWebView.showFooter = false
        //        kireiWebView.enableOpenInSafari = true
        //        kireiWebView.openInSafariText = "Safariでみる"
        //        kireiWebView.enablePcUserAgent = true
        //        kireiWebView.shareButtonAction = { url, title in
        //            println(title)
        //            println(url)
        //        }
        self.presentViewController(kireiWebView, animated: true, completion: nil)
    }
}




extension NSTimer {
    class func schedule(delay delay: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
    class func schedule(repeatInterval interval: NSTimeInterval, handler: NSTimer! -> Void) -> NSTimer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0, handler)
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes)
        return timer
    }
}




