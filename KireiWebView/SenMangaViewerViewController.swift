//
//  SenMangaCarouselWebViewController.swift
//  KireiWebView
//
//  Created by Takuya Okamoto on 2017/05/03.
//  Copyright © 2017 Uniface. All rights reserved.
//

import UIKit
import WebKit

/*
 チャプターは単純な数字とはかぎらない。だから最後の数字をひたすらインクリメントしていく。
 1ページづつ読み込んで、順番にappendしていく。
 読み込み後、に次のページがあるかどうかをJavascriptを実行して確認する。
*/
class SenMangaViewerViewController: UIViewController {
 
    private let header = ViewerHeaderView()
    private let scrollView = UIScrollView()
 
    private let firstUrl: String// http://raw.senmanga.com/Tokyo-Ghoul:RE/146/1
    private let baseUrl : String// http://raw.senmanga.com/Tokyo-Ghoul:RE/146/
    private var pageCounter = 0
    private var webViews: [UIView] = []
    
    init(firstUrl:String) {
        self.firstUrl = firstUrl
        self.baseUrl = firstUrl.characters.split(separator: "/").dropLast().map(String.init).joined(separator: "/") + "/"
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        appendNext()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - setup
    
    func setup() {
        scrollView.isDirectionalLockEnabled = true
        scrollView.isPagingEnabled = true
        scrollView.indicatorStyle = .white
        header.didTapCloseButton = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(header)
        view.addSubview(scrollView)

        header.snp.makeConstraints { make in
            make.right.left.top.equalTo(view)
            make.height.equalTo(44)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.left.right.bottom.equalTo(view)
        }
    }

    // MARK: - append next

    func appendNext() {
        pageCounter += 1
        
        let url = getUrl(page: pageCounter)
        print(url)
        
        let pageView = MangaViewerView(url: url)
        pageView.backgroundColor = .black
        pageView.didFinishNavigation = { [weak self] webview in
            let isLastPage = "(function() {  if(document.getElementById('picture') == undefined) { return true }; var disabled = document.querySelectorAll('span.disabled'); for (elm of disabled) { if (elm.innerHTML == 'Next Page') { return true; } } return false; })();"
            webview.evaluateJavaScript(isLastPage) { (res: Any?, error: Error?) -> Void in
                print("❗res: \(res ?? "nil")")
                guard let isLast = res as? Bool else { return }
                if !isLast {
                    self?.appendNext()
                }
            }
        }

        appendPageView(pageView)
        
        if pageCounter > 1 {
            // 足した分右へスクロール
            scrollView.setContentOffset(CGPoint(
                x: scrollView.contentOffset.x + view.frame.width,
                y: 0
            ), animated: false)
        }
    }
    
    func appendPageView(_ view: UIView) {
        scrollView.addSubview(view)
        webViews.append(view)
        reLayoutContents()
    }
    
    func reLayoutContents() {
        scrollView.contentSize = CGSize(
            width: view.frame.width * CGFloat(webViews.count),
            height: scrollView.frame.height
        )
        
        var previousView: UIView!
        
        webViews.reversed().enumerated().forEach { i, v in
            v.snp.remakeConstraints { make in
                make.top.equalTo(scrollView)
                make.size.equalTo(scrollView)
                if i == 0 {
                    make.left.equalTo(0)
                } else {
                    make.left.equalTo(previousView.snp.right)
                }
            }
            previousView = v
        }
    }

    func getUrl(page: Int) -> String {
        return baseUrl + String(page)
    }
}

extension SenMangaViewerViewController {
    
    class func isSenMangaContentPage(url: String) -> Bool {
        // ex: http://raw.senmanga.com/Tokyo-Ghoul:RE/146/1
        let regEx = "((https|http)://)raw.senmanga.com/(\\w|-|:|.)+/(\\w|-|.)+/([0-9]+)"
        return NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx]).evaluate(with: url)
    }
}

fileprivate class MangaViewerView: UIView, WKNavigationDelegate {
    
    let webview = WebViewFactory.injectedMangaCSS()
    var didFinishNavigation: ((WKWebView) -> Void)?
    
    init(url: String) {
        super.init(frame: .zero)
        self.addSubview(webview)
        webview.snp.makeConstraints { make in make.edges.equalTo(self) }
        webview.navigationDelegate  = self
        webview.scrollView.isScrollEnabled = false
        
        if let url = URL(string: url) {
            webview.load(URLRequest(url: url))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didFinishNavigation?(webview)
    }
}

fileprivate class ViewerHeaderView: UIView {
    
    let closeButton = UIButton()
    var didTapCloseButton: (()->Void)?
    
    init() {
        super.init(frame: .zero)
        
        self.addSubview(closeButton)
        closeButton.setImage(imageNamed("close"), for: UIControlState())
        closeButton.snp.makeConstraints { make in
            make.width.equalTo(44)
            make.left.top.bottom.equalTo(self)
        }
        closeButton.addTarget(self, action: #selector(self.didTapCloseButtonAction), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapCloseButtonAction() {
        self.didTapCloseButton?()
    }
    
    private func imageNamed(_ name:String) -> UIImage? {
        return UIImage(named: name, in: Bundle(for: KireiWebViewController.self), compatibleWith: nil)
    }
}
