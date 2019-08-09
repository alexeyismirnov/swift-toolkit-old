//
//  BookModel.swift
//  ponomar
//
//  Created by Alexey Smirnov on 5/19/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import Foundation

public enum BookType {
    case text, html
}

public struct BookPosition {
    public init(model: BookModel, index: IndexPath, chapter: Int) {
        self.model = model
        self.index = index
        self.chapter = chapter
    }
    
    public init(model: BookModel, location: String) {
        self.model = model
        self.location = location
    }
    
    public init(model: BookModel, data: Any) {
        self.model = model
        self.data = data
    }
    
    public init(index: IndexPath, chapter: Int) {
        self.index = index
        self.chapter = chapter
    }
    
    public var model : BookModel?
    public var index : IndexPath?
    public var chapter : Int?
    public var location: String?
    public var data: Any?
}

public protocol BookModel {
    var code : String { get }
    var mode : BookType { get }
    var title: String { get }
    
    var isExpandable : Bool { get }
    var hasNavigation : Bool { get }
    
    func getSections() -> [String]
    func getItems(_ section : Int) -> [String]
    
    func getNumChapters(_ index : IndexPath) -> Int
    func getComment(commentId: Int) -> String?
    
    func getContent(at pos: BookPosition) -> Any?
    func getBookmark(at pos: BookPosition) -> String
    
    func getNextSection(at pos: BookPosition) -> BookPosition?
    func getPrevSection(at pos: BookPosition) -> BookPosition?
    
    func getBookmarkName(_ bookmark : String) -> String
}
