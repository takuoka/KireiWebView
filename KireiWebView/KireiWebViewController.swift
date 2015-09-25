//
//  KireiWebView.swift
//  KireiWebView
//
//  Created by Takuya Okamoto on 2015/07/09.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

public class KireiWebViewController: UIViewController, WKNavigationDelegate {
    
    public var shareButtonAction: ((url:NSURL?, title:String?)->())? = nil
    public var enableOpenInSafari = false
    public var openInSafariText = "Open in Safari"
    public var enablePcUserAgent = false
    public var showFooter = true
    
    private let initialURL:String
    
    var webView: WKWebView!
    let shareButton = UIButton()
    let closeButton = UIButton()
    let safariButton = UIButton()
    let titleLabel = UILabel()
    let backButton = UIButton()
    let forwardButton = UIButton()

    
    
    
    public init(url:String){
        initialURL = url
        super.init(nibName: nil, bundle: nil)
    }
    public required init?(coder aDecoder: NSCoder) {
        initialURL = ""
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if enablePcUserAgent == true {
            changeUserAgentAsPC()
        }

        webView = WKWebView()
        webView.navigationDelegate = self
        
        layout()
        setupButtonActions()
    
        if let url = NSURL(string: initialURL){
            webView.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    
    
    public func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        titleLabel.text = webView.title
        
        if webView.backForwardList.backList.count > 0 {
            backButton.enabled = true
        }
        else {
            backButton.enabled = false
        }
        
        if webView.backForwardList.forwardList.count > 0 {
            forwardButton.enabled = true
        }
        else {
            forwardButton.enabled = false
        }
    }
    
    
    

    func setupButtonActions() {
        shareButton.addTarget(self, action: "didTapShareButton", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.addTarget(self, action: "didTapCloseButton", forControlEvents: UIControlEvents.TouchUpInside)
        safariButton.addTarget(self, action: "didTapSafariButton", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.addTarget(self, action: "didTapBackButton", forControlEvents: UIControlEvents.TouchUpInside)
        forwardButton.addTarget(self, action: "didTapForwardButton", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func didTapBackButton() {
        webView.goBack()
    }
    
    func didTapForwardButton() {
        webView.goForward()
    }
    
    func didTapSafariButton() {
        openSafari(webView.URL)
    }
    
    func didTapCloseButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapShareButton() {
        if shareButtonAction != nil {
            shareButtonAction!(url:webView.URL, title:webView.title)
        }
        else {
            openActivityView(nil)
        }
    }
}

