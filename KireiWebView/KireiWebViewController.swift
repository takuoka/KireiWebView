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

public class KireiWebViewController: UIViewController {
    
    public var shareButtonAction: ((url:NSURL?, title:String?)->())? = nil
    public var enableOpenInSafari = false
    public var openInSafariText = "Open in Safari"
    public var enablePcUserAgent = false
    public var showFooter = true

    private let initialURL:String

    var webview = WKWebView()
    let progressView = UIProgressView()
    let shareButton = UIButton()
    let closeButton = UIButton()
    let safariButton = UIButton()
    let titleLabel = UILabel()
    let backButton = UIButton()
    let forwardButton = UIButton()
    let addBookmarkButton = UIButton()
    
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
    
    let blackList: [String] = [
        "addthis.com"
    ]
    
    let whiteList: [String] = [
        "raw.senmanga.com"
    ]
}

extension KireiWebViewController: WKNavigationDelegate {

    public func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.URL else {
            decisionHandler(.Allow)
            return
        }
        let urlStr = url.absoluteString
        for black in blackList {
            if urlStr.containsString(black) {
                print("❌ \(url.absoluteString)")
                decisionHandler(.Cancel)
                return
            }
        }
        for white in whiteList {
            if urlStr.containsString(white) {
                print("👌 \(url.absoluteString)")
                decisionHandler(.Allow)
                return
            }
        }
        print("❌ \(url.absoluteString)")
        decisionHandler(.Cancel)
        return
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
}

// MARK: tap events
extension KireiWebViewController {
    
    func setupButtonActions() {
        shareButton.addTarget(self, action: #selector(self.dynamicType.didTapShareButton), forControlEvents: .TouchUpInside)
        closeButton.addTarget(self, action: #selector(self.dynamicType.didTapCloseButton), forControlEvents: .TouchUpInside)
        safariButton.addTarget(self, action: #selector(self.dynamicType.didTapSafariButton), forControlEvents: .TouchUpInside)
        backButton.addTarget(self, action: #selector(self.dynamicType.didTapBackButton), forControlEvents: .TouchUpInside)
        forwardButton.addTarget(self, action: #selector(self.dynamicType.didTapForwardButton), forControlEvents: .TouchUpInside)
        addBookmarkButton.addTarget(self, action: #selector(self.dynamicType.didTapAddBookmarkButton), forControlEvents: .TouchUpInside)
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
    
    func didTapAddBookmarkButton() {
        guard let url = webview.URL?.absoluteString, title = webview.title else {
            showAlert("Can't get URL and Title.")
            return
        }
        let bookmark = Bookmark(url: url, title: title)
        let result = BookmarkStore.addBookmark(bookmark)
        switch result {
//        case .Failed:
//            showAlert("failed.")
        case .AleadyExist:
            showAlert("This page is aleady exist.")
        case .Success:
            showAlert("Success.")
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

// MARK: observe progress bar
extension KireiWebViewController {
    
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
//            self.progressView.hidden = loading
            if !loading {
                self.progressView.progress = 0
            }
        }
    }
}