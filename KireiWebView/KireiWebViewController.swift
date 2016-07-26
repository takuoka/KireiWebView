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
    
    var webview: WKWebView!
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

        webview = WKWebView()
        webview.navigationDelegate = self
        
        layout()
        setupButtonActions()
    
        if let url = NSURL(string: initialURL){
            webview.loadRequest(NSURLRequest(URL: url))
        }
        
        startObserveForProgressBar()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeOvserverForProgressBar()
    }
    
    public func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        titleLabel.text = self.webview.URL?.absoluteString
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
        webview.goBack()
    }
    
    func didTapForwardButton() {
        webview.goForward()
    }
    
    func didTapSafariButton() {
        openSafari(webview.URL)
    }
    
    func didTapCloseButton() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapShareButton() {
        if shareButtonAction != nil {
            shareButtonAction!(url:webview.URL, title:webview.title)
        }
        else {
            openActivityView(nil)
        }
    }
    
    
    // MARK: observe progress bar
    
    func startObserveForProgressBar() {
        self.webview.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    
    func removeOvserverForProgressBar() {
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.removeObserver(self, forKeyPath: "loading")
    }
    
    override public func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            self.progressView.setProgress(Float(self.webview.estimatedProgress), animated: true)
        } else if keyPath == "loading" {
            let loading = self.webview.loading
            UIApplication.sharedApplication().networkActivityIndicatorVisible = loading
            self.progressView.hidden = loading
            if !loading {
                self.progressView.progress = 0
            }
        }
    }
}

