//
//  RequestBolocker.swift
//  KireiWebView
//
//  Created by Takuya Okamoto on 2016/09/23.
//  Copyright © 2016 Uniface. All rights reserved.
//

import Foundation

public class RequestBolocker {

    /// request blocking is enabled at only this site.
    /// If this is empty, it is enabled at all site.
    public var enableAreas: [String] = [
        "raw.senmanga.com"
    ]
    
    /// Allow request only this site
    public var whiteList: [String] = [
        "raw.senmanga.com"
    ]
    
    /// Even if url is white, when url contains black, then block it.
    public var blackList: [String] = [
        "addthis.com"
    ]
    
    func shouldBlockRequest(url: String, fromHere here: String?) -> Bool {

        var enableBloking = false

        if let here = here {
            for enabledArea in enableAreas {
                if here.contains(enabledArea) {
                    enableBloking = true
                    break
                }
            }
        } else {
            return false
        }

        guard enableBloking else { return false }
        
        for black in blackList {
            if url.contains(black) {
                return true
            }
        }

        for white in whiteList {
            if url.contains(white) {
                return false
            }
        }
        
        return true
    }
}
