//
//  BookmarksModel.swift
//  ponomar
//
//  Created by Alexey Smirnov on 5/12/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import UIKit

public class BookmarksModel : BookModel {
    public var code = "Bookmarks"
    public var lang = Translate.language

    public var title: String {
        get { return Translate.s("Bookmarks...") }
    }
    
    public var contentType: BookContentType = .text

    public var hasChapters = false

    public var hasDate = false
    public var date: Date = Date()
    
    public static var books = [BookModel]()
    
    let prefs = AppGroup.prefs!
    public static let shared = BookmarksModel()
    
    public func getSections() -> [String] {
        let bookmarks = prefs.stringArray(forKey: "bookmarks")!
        return (bookmarks.count == 0) ? [String]() : [""]
    }
    
    public func getItems(_ section: Int) -> [String] {
        let bookmarks = prefs.stringArray(forKey: "bookmarks")!
        
        var arr = [String]()
        
        for b in bookmarks {
            let comp = b.components(separatedBy: "_")
            let model = BookmarksModel.books.filter() { $0.code == comp[0] }.first!
            
            arr.append(model.getBookmarkName(b))
        }

        return arr
    }

    public func getNumChapters(_ index: IndexPath) -> Int { return 0 }
    
    public func getComment(commentId: Int) -> String? { return nil }
    
    public func resolveBookmarkAt(row: Int) -> BookPosition {
        let bookmarks = prefs.stringArray(forKey: "bookmarks")!
        let comp = bookmarks[row].components(separatedBy: "_")
        
        let model = BookmarksModel.books.filter() { $0.code == comp[0] }.first!
        let index = IndexPath(row: Int(comp[2])!, section: Int(comp[1])!)
        let chapter : Int = (comp.count == 4) ? Int(comp[3])! : 0
        
        return BookPosition(model: model, index: index, chapter: chapter)
    }
    
    public func getContent(at pos: BookPosition) -> Any? { return nil }
    
}

