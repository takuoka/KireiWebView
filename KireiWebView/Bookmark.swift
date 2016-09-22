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
    
    // MARK: convert to Data for Store
    
    func toDictionary() -> [String : String] {
        return [
            "url": url,
            "title": title
        ]
    }
    
    static func fromDictionary(_ d: [String : String]) -> Bookmark? {
        guard
            let url = d["url"],
            let title = d["title"]
        else {
            return nil
        }
        return Bookmark(url: url, title: title)
    }
}

class BookmarkStore {
    
    private class func defaultBookmarks() -> [Bookmark] {
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
    
    class func clearAll() {
        UserDefault.bookmarks = []
    }
}

enum BookmarkAddResult {
    case success
    case aleadyExist
}

private extension UserDefaults {

    var bookmarkStoreKey: String { return "BookmarkList" }
    
    var bookmarks:[Bookmark] {
        set {
            let data = newValue.map { $0.toDictionary() }
            self.set(data, forKey: bookmarkStoreKey)
        }
        get{
            let data = self.object(forKey: bookmarkStoreKey) as? [[String : String]] ?? []
            return data.reduce([]) { (ary, d: [String : String]) -> [Bookmark] in
                guard let bookmark = Bookmark.fromDictionary(d) else { return ary }
                return ary + [bookmark]
            }
        }
    }
}

private let UserDefault = UserDefaults.standard
