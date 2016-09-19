//
//  BookmarksTableViewController.swift
//  KireiWebView
//
//  Created by Takuya Okamoto on 2016/09/20.
//  Copyright © 2016 Uniface. All rights reserved.
//

import UIKit

class BookmarksTableViewController: UITableViewController {

    var bookmarks: [Bookmark] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    func update() {
        bookmarks = BookmarkStore.load() ?? []
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL") ?? UITableViewCell()
        let bookmark = bookmarks[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = bookmark.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookmark = bookmarks[(indexPath as NSIndexPath).row]
        let webview = KireiWebViewController(url: bookmark.url)
        present(webview, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "delete") { [weak self] action, indexPath in
            guard let `self` = self else { return }
            let bookmark = self.bookmarks[(indexPath as NSIndexPath).row]
            BookmarkStore.removeBookmark(bookmark)
            self.update()
        }
        delete.backgroundColor = UIColor.red
        return [delete]
    }
}
