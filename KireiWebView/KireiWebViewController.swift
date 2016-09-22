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

open class KireiWebViewController: UIViewController {
    
    open var shareButtonAction: ((_ url:URL?, _ title:String?)->())? = nil
    open var enableOpenInSafari = false
    open var openInSafariText = "Open in Safari"
    open var enablePcUserAgent = false
    open var showFooter = true
    public var requestBlockerList: [RequestBolocker] = []

    fileprivate let initialURL:String

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
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        startObserveForProgressBar()

        if enablePcUserAgent == true {
            changeUserAgentAsPC()
        }

        webview.navigationDelegate = self

        layout()

        setupButtonActions()

        if let url = URL(string: initialURL){
            webview.load(URLRequest(url: url))
        }
        
        /// manga hack
        let mangaAdBlocker = RequestBolocker()
        mangaAdBlocker.enableAreas = ["raw.senmanga.com"]
        mangaAdBlocker.whiteList = ["raw.senmanga.com"]
        mangaAdBlocker.blackList = ["addthis.com"]
        requestBlockerList.append(mangaAdBlocker)
    }
    
    deinit {
        removeOvserverForProgressBar()
    }
}

extension KireiWebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        titleLabel.text = self.webview.url?.absoluteString
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        titleLabel.text = webView.title
        
        if webView.backForwardList.backList.count > 0 {
            backButton.isEnabled = true
        }
        else {
            backButton.isEnabled = false
        }
        
        if webView.backForwardList.forwardList.count > 0 {
            forwardButton.isEnabled = true
        }
        else {
            forwardButton.isEnabled = false
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Ad Blocking
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        var shouldBlock = false
        let urlStr = url.absoluteString
        let here = webView.url?.absoluteURL.absoluteString
        for blocker in requestBlockerList {
            if blocker.shouldBlockRequest(url: urlStr, fromHere: here) {
                shouldBlock = true
            }
        }
        decisionHandler(shouldBlock ? .cancel : .allow)
        return
    }
}

// MARK: tap events
extension KireiWebViewController {
    
    func setupButtonActions() {
        shareButton.addTarget(self, action: #selector(type(of: self).didTapShareButton), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(type(of: self).didTapCloseButton), for: .touchUpInside)
        safariButton.addTarget(self, action: #selector(type(of: self).didTapSafariButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(type(of: self).didTapBackButton), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(type(of: self).didTapForwardButton), for: .touchUpInside)
        addBookmarkButton.addTarget(self, action: #selector(type(of: self).didTapAddBookmarkButton), for: .touchUpInside)
    }
    
    func didTapBackButton() {
        webview.goBack()
    }
    
    func didTapForwardButton() {
        webview.goForward()
    }
    
    func didTapSafariButton() {
        openSafari(webview.url)
    }
    
    func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func didTapShareButton() {
        if let action = shareButtonAction {
            action(webview.url, webview.title)
        } else {
            openActivityView(nil)
        }
    }
    
    func didTapAddBookmarkButton() {
        addHereToBookmark()
    }
}

// MARK: - Observe Progress Bar

extension KireiWebViewController {
    
    func startObserveForProgressBar() {
        self.webview.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        self.webview.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    func removeOvserverForProgressBar() {
        self.webview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.webview.removeObserver(self, forKeyPath: "loading")
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressView.setProgress(Float(self.webview.estimatedProgress), animated: true)
        } else if keyPath == "loading" {
            let loading = self.webview.isLoading
            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
            if !loading {
                self.progressView.progress = 0
            }
        }
    }
}

// MARK: - Bookmark Action

extension KireiWebViewController {
    
    func addHereToBookmark() {
        guard let url = webview.url?.absoluteString, let title = webview.title else {
            showAlert("Can't get URL and Title.")
            return
        }
        let bookmark = Bookmark(url: url, title: title)
        let result = BookmarkStore.addBookmark(bookmark)
        switch result {
        case .aleadyExist:
            showAlert("This page is aleady exist.")
        case .success:
            showAlert("Success.")
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
