//
//  Bookmark.swift
//  KireiWebView
//
//  Created by Takuya Okamoto on 2016/09/20.
//  Copyright © 2016 Uniface. All rights reserved.
//

import Foundation

struct Bookmark {
    
    let url: String
    let title: String
    
    init(url:String, title:String) {
        self.url = url
        self.title = title
    }
}

class BookmarkStore {
    
    private class func defaultBookmarks() -> [Bookmark] {
        return [
            Bookmark(url: "https://google.com", title: "google"),
            Bookmark(url: "http://raw.senmanga.com/release", title: "sen manga"),
        ]
    }
    
    class func load() -> [Bookmark] {
        let loaded = UserDefault.bookmarks
        guard loaded.count > 0 else {
            return defaultBookmarks()
        }
        return loaded
    }

    class func save(bookmarks: [Bookmark]) {
        UserDefault.bookmarks = bookmarks
    }
    
    class func addBookmark(bookmark: Bookmark) -> BookmarkAddResult {
        var list: [Bookmark] = load()
        for b in list {
            if b.url == bookmark.url {
                return .AleadyExist
            }
        }
        list.append(bookmark)
        save(list)
        return .Success
    }
    
    class func removeBookmark(bookmark: Bookmark) {
        let list: [Bookmark] = load()
        let removedList = list.filter { $0.url != bookmark.url }
        save(removedList)
    }
}

enum BookmarkAddResult {
    case Success
    case AleadyExist
}

private extension NSUserDefaults {

    var bookmarks:[Bookmark]{

        set(datas){
            // Swiftのオブジェクトを、NSObjectなオブジェクトに変換する
            let newDatas: [NSDictionary] = datas.map {
                [
                    "url": $0.url,
                    "title": $0.title
                ] as NSDictionary
            }
            // NSObjectなオブジェクトのみになったから、setObjectできる
            self.setObject(newDatas,forKey: "BookmarkList")
        }

        get{
            let datas = self.objectForKey("BookmarkList") as? [NSDictionary] ?? []
            let array = datas.reduce([]){ (ary, d: NSDictionary) -> [Bookmark] in
                if let
                    url = d["url"] as? String,
                    title = d["title"] as? String {
                    return ary + [Bookmark(url: url, title: title)]
                } else {
                    return ary
                }
            }
            return array
        }
    }
}

private let UserDefault = NSUserDefaults.standardUserDefaults()