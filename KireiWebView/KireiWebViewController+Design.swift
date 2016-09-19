//
//  KireiWebViewController+Design.swift
//  KireiWebView
//
//  Created by Takuya Okamoto on 2015/07/09.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit
import SnapKit


extension KireiWebViewController {
    
    func layout() {
        let header = UIView()
        let footer = UIView()

        progressView.progressViewStyle = .bar
        progressView.alpha = 0.5

        header.backgroundColor = UIColor(white: 248/255, alpha: 1)
        footer.backgroundColor = UIColor(white: 248/255, alpha: 1)
        
        let headerBorder = UIView()
        let footerBorder = UIView()
        headerBorder.backgroundColor = UIColor(white: 151/255, alpha: 1)
        footerBorder.backgroundColor = UIColor(white: 151/255, alpha: 1)
        header.addSubview(headerBorder)
        footer.addSubview(footerBorder)
        
        self.view.addSubview(webview)
        self.view.addSubview(header)
        self.view.addSubview(progressView)
        self.view.addSubview(footer)
        
        header.snp_makeConstraints { make in
            make.top.left.right.equalTo(self.view)
            make.height.equalTo(44 + 20)//68
        }
        footer.snp_makeConstraints { make in
            make.bottom.left.right.equalTo(self.view)
            make.height.equalTo(44)//50
        }
        headerBorder.snp_makeConstraints { make in
            make.bottom.equalTo(header.snp_bottom)
            make.height.equalTo(0.5)
            make.left.right.equalTo(self.view)
        }
        footerBorder.snp_makeConstraints { make in
            make.top.equalTo(footer.snp_top)
            make.height.equalTo(0.5)
            make.left.right.equalTo(self.view)
        }
        
        webview.snp_makeConstraints { make in
            make.top.equalTo(header.snp_bottom)
            make.bottom.equalTo(footer.snp_top)
            make.right.left.equalTo(self.view)
        }
        
        progressView.snp_makeConstraints { make in
            make.top.equalTo(header.snp_bottom)
            make.right.left.equalTo(self.view)
            make.height.equalTo(4)
        }
        
        layoutHeader(header)
        layoutFooter(footer)
        
        if showFooter == false {
            footer.isHidden = true
            webview.snp_updateConstraints { make in
                make.bottom.equalTo(self.view)
            }
        }
    }
    
    func layoutHeader(_ header:UIView) {
        
        let rect = UIView()
        
        closeButton.setImage(imageNamed("close"), for: UIControlState())
        
        titleLabel.font = hirakakuFont(14)
        titleLabel.textColor = UIColor(white: 134/255, alpha: 1)
        
        rect.addSubview(closeButton)
        rect.addSubview(titleLabel)
        header.addSubview(rect)
        
        
        rect.snp_makeConstraints { make in
            make.top.equalTo(20)//status bar
            make.right.left.bottom.equalTo(header)
        }
        closeButton.snp_makeConstraints { make in
            make.size.equalTo(44)
            make.left.equalTo(header)
            make.centerY.equalTo(rect)
        }
        titleLabel.snp_makeConstraints { make in
            make.left.equalTo(closeButton.snp_right).offset(2)
            make.right.equalTo(self.view).offset(-16)//?
            make.centerY.equalTo(closeButton)
            make.height.equalTo(rect)
        }
    }
    
    func layoutFooter(_ footer:UIView) {
        
        // left
        
        backButton.setImage(imageNamed("back"), for: UIControlState())
        forwardButton.setImage(imageNamed("next"), for: UIControlState())
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
        footer.addSubview(backButton)
        footer.addSubview(forwardButton)
        
        backButton.snp_makeConstraints { make in
            make.size.equalTo(44)
            make.left.equalTo(footer)
            make.centerY.equalTo(footer)
        }
        forwardButton.snp_makeConstraints { make in
            make.size.equalTo(44)
            make.left.equalTo(backButton.snp_right).offset(2)
            make.centerY.equalTo(footer)
        }
        
        // right
        
        shareButton.setImage(imageNamed("share"), for: UIControlState())
        addBookmarkButton.setImage(imageNamed("add-to-bookmark"), for: UIControlState())
        let paddingB: CGFloat = 12
        addBookmarkButton.imageEdgeInsets = UIEdgeInsets(top: paddingB, left: paddingB, bottom: paddingB, right: paddingB)

        footer.addSubview(shareButton)
        footer.addSubview(addBookmarkButton)

        shareButton.snp_makeConstraints { make in
            make.size.equalTo(44)
            make.right.equalTo(footer)
            make.centerY.equalTo(footer)
        }

        addBookmarkButton.snp_makeConstraints { make in
            make.size.equalTo(44)
            make.right.equalTo(shareButton.snp_left).offset(-2)
            make.centerY.equalTo(footer)
        }
        
        safariButton.setTitle(openInSafariText, for: UIControlState())
        safariButton.setTitleColor(UIColor(white: 134/255, alpha: 1), for: UIControlState())
        safariButton.setTitleColor(UIColor(white: 134/255, alpha: 0.75), for: UIControlState.highlighted)
        safariButton.titleLabel?.font = hirakakuFont(14)
        footer.addSubview(safariButton)
        safariButton.snp_makeConstraints { make in
            make.center.equalTo(footer)
            make.height.equalTo(footer)
        }
        
        if enableOpenInSafari == false {
            safariButton.isHidden = true
        }
    }
}


