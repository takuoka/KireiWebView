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

        header.backgroundColor = UIColor(white: 248/255, alpha: 1)
        footer.backgroundColor = UIColor(white: 248/255, alpha: 1)
        
        let headerBorder = UIView()
        let footerBorder = UIView()
        headerBorder.backgroundColor = UIColor(white: 151/255, alpha: 1)
        footerBorder.backgroundColor = UIColor(white: 151/255, alpha: 1)
        header.addSubview(headerBorder)
        footer.addSubview(footerBorder)
        
        self.view.addSubview(webView)
        self.view.addSubview(header)
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
        
        webView.snp_makeConstraints { make in
            make.top.equalTo(header.snp_bottom)
            make.bottom.equalTo(footer.snp_top)
            make.right.left.equalTo(self.view)
        }
        
        layoutHeader(header)
        layoutFooter(footer)
        
        if showFooter == false {
            footer.hidden = true
            webView.snp_updateConstraints { make in
                make.bottom.equalTo(self.view)
            }
        }
    }
    
    func layoutHeader(header:UIView) {
        
        let rect = UIView()
        
        closeButton.setImage(imageNamed("close"), forState: UIControlState.Normal)
        
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
    
    func layoutFooter(footer:UIView) {        
        backButton.setImage(imageNamed("back"), forState: .Normal)
        forwardButton.setImage(imageNamed("next"), forState: .Normal)
        
        backButton.enabled = false
        forwardButton.enabled = false
        
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
        
        shareButton.setImage(imageNamed("share"), forState: .Normal)
        footer.addSubview(shareButton)
        shareButton.snp_makeConstraints { make in
            make.size.equalTo(44)
            make.right.equalTo(footer)
            make.centerY.equalTo(footer)
        }
        
        safariButton.setTitle(openInSafariText, forState: .Normal)
        safariButton.setTitleColor(UIColor(white: 134/255, alpha: 1), forState: .Normal)
        safariButton.setTitleColor(UIColor(white: 134/255, alpha: 0.75), forState: UIControlState.Highlighted)
        safariButton.titleLabel?.font = hirakakuFont(14)
        footer.addSubview(safariButton)
        safariButton.snp_makeConstraints { make in
            make.center.equalTo(footer)
            make.height.equalTo(footer)
        }
        
        if enableOpenInSafari == false {
            safariButton.hidden = true
        }
    }
}


