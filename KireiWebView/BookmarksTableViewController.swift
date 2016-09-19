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
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CELL")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    func update() {
        bookmarks = BookmarkStore.load() ?? []
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CELL") ?? UITableViewCell()
        let bookmark = bookmarks[indexPath.row]
        cell.textLabel?.text = bookmark.title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bookmark = bookmarks[indexPath.row]
        let webview = KireiWebViewController(url: bookmark.url)
        presentViewController(webview, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Default, title: "delete") { [weak self] action, indexPath in
            guard let `self` = self else { return }
            let bookmark = self.bookmarks[indexPath.row]
            BookmarkStore.removeBookmark(bookmark)
            self.update()
        }
        delete.backgroundColor = UIColor.redColor()
        return [delete]
    }
}
