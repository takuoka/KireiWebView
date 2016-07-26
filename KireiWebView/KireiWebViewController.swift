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
    let progressView = UIProgressView()
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
        
        startObserveForProgressBar()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeOvserverForProgressBar()
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
        shareButton.addTarget(self, action: #selector(KireiWebViewController.didTapShareButton), forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.addTarget(self, action: #selector(KireiWebViewController.didTapCloseButton), forControlEvents: UIControlEvents.TouchUpInside)
        safariButton.addTarget(self, action: #selector(KireiWebViewController.didTapSafariButton), forControlEvents: UIControlEvents.TouchUpInside)
        backButton.addTarget(self, action: #selector(KireiWebViewController.didTapBackButton), forControlEvents: UIControlEvents.TouchUpInside)
        forwardButton.addTarget(self, action: #selector(KireiWebViewController.didTapForwardButton), forControlEvents: UIControlEvents.TouchUpInside)
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
    
    
    // MARK: プログレスバー用の監視
    
    func startObserveForProgressBar() {
        self.webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    func removeOvserverForProgressBar() {
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webView.removeObserver(self, forKeyPath: "loading")
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            self.progressView.setProgress(Float(self.webView.estimatedProgress), animated: true)
        } else if keyPath == "loading" {
            let loading = self.webView.loading
            UIApplication.sharedApplication().networkActivityIndicatorVisible = loading
            self.progressView.hidden = loading
            if !loading {
                self.progressView.progress = 0
            }
        }
    }
}

