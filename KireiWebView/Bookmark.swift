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
    
    fileprivate class func defaultBookmarks() -> [Bookmark] {
        return [
            Bookmark(url: "https://google.com", title: "google"),
            Bookmark(url: "http://raw.senmanga.com/release", title: "sen manga"),
            Bookmark(url: "http://urasunday.com/mobupsycho100/", title: "mobupsycho100")
        ]
    }
    
    class func load() -> [Bookmark] {
        let loaded = UserDefault.bookmarks
        guard loaded.count > 0 else {
            return defaultBookmarks()
        }
        return loaded
    }

    class func save(_ bookmarks: [Bookmark]) {
        UserDefault.bookmarks = bookmarks
    }
    
    class func addBookmark(_ bookmark: Bookmark) -> BookmarkAddResult {
        var list: [Bookmark] = load()
        for b in list {
            if b.url == bookmark.url {
                return .aleadyExist
            }
        }
        list.append(bookmark)
        save(list)
        return .success
    }
    
    class func removeBookmark(_ bookmark: Bookmark) {
        let list: [Bookmark] = load()
        let removedList = list.filter { $0.url != bookmark.url }
        save(removedList)
    }
}

enum BookmarkAddResult {
    case success
    case aleadyExist
}

private extension UserDefaults {

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
            self.set(newDatas,forKey: "BookmarkList")
        }

        get{
            let datas = self.object(forKey: "BookmarkList") as? [NSDictionary] ?? []
            let array = datas.reduce([]){ (ary, d: NSDictionary) -> [Bookmark] in
                if let
                    url = d["url"] as? String,
                    let title = d["title"] as? String {
                    return ary + [Bookmark(url: url, title: title)]
                } else {
                    return ary
                }
            }
            return array
        }
    }
}

private let UserDefault = UserDefaults.standard
