//
//  WebViewFactory.swift
//  KireiWebView
//
//  Created by Takuya Okamoto on 2017/05/03.
//  Copyright © 2017 Uniface. All rights reserved.
//

import UIKit
import WebKit

class WebViewFactory {
    
    class func injectedMangaCSS() -> WKWebView {

        let script = "var element = document.getElementById('picture');element.style.position = 'absolute';element.style.left = '0';element.style.top = '0';element.style.zIndex = '999';element.style.width = '100%';element.style.border = 'none';document.body.style.backgroundColor = '#000';"
        
        let userScript1 = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        
        let controller = WKUserContentController()
        controller.addUserScript(userScript1)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = controller
        
        return WKWebView(frame: .zero, configuration: configuration)
    }
}
