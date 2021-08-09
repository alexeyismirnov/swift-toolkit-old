//
//  BibleModel.swift
//  ponomar
//
//  Created by Alexey Smirnov on 3/7/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import UIKit
import Squeal

public class BibleUtils {
    static public func decorateLine(num verse:Int64, text content:String, fontSize:CGFloat, lang: String, isPsalm: Bool = false) -> NSAttributedString {
        if isPsalm {
            let text = NSMutableAttributedString(attributedString: content.colored(with: Theme.textColor).systemFont(ofSize: fontSize))
            
            if lang == "en" ||  lang == "ru" {
                if let r = content.range(of: ".", options:[], range: nil) {
                    let r2 = content.startIndex..<r.upperBound
                    
                    text.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(r2, in: content))
                }
            }

            return "\(verse) ".colored(with: UIColor.red).systemFont(ofSize: fontSize) + text + "\n"
        }
        
        var text = NSAttributedString()
        text += "\(verse) ".colored(with: UIColor.red) + content.colored(with: Theme.textColor) + "\n"
        
        return text.systemFont(ofSize: fontSize)
    }
    
    static public func getText(_ name: String, whereExpr: String, lang: String) -> [[String:Bindable?]] {
        let path = Bundle.main.path(forResource: name.lowercased()+"_"+lang, ofType: "sqlite")!
        let db = try! Database(path:path)
        
        return try! db.selectFrom("scripture", whereExpr:whereExpr) { ["verse": $0["verse"], "text": $0["text"]] }
    }
    
}

public protocol BibleModel {
    func numberOfChapters(_ name: String) -> Int
    func getChapter(_ name: String, _ chapter: Int) -> NSAttributedString
}

public extension BibleModel where Self:BookModel {
    func numberOfChapters(_ name: String) -> Int {
        let path = Bundle.main.path(forResource: name.lowercased()+"_"+lang, ofType: "sqlite")!
        let db = try! Database(path:path)
        
        let results = try! db.prepareStatement("SELECT COUNT(DISTINCT chapter) FROM scripture")
        
        while try! results.next() {
            let num = results[0] as! Int64
            return Int(num)
        }
        
        return 0
    }
    
    func getChapter(_ name: String, _ chapter: Int) -> NSAttributedString {
        var text = NSAttributedString()
        
        let prefs = AppGroup.prefs!
        let fontSize = prefs.integer(forKey: "fontSize")
        
        for line in BibleUtils.getText(name, whereExpr: "chapter=\(chapter)", lang: lang) {
            let row  = BibleUtils.decorateLine(num: line["verse"] as! Int64,
                                               text: line["text"] as! String,
                                               fontSize: CGFloat(fontSize),
                                               lang: lang,
                                               isPsalm:name == "ps")
            text = text + row
        }
        
        return text
    }
    
}

public class OldTestamentModel : BookModel, BibleModel {
    public var lang: String
    
    public var code : String {
        get { return lang == "ru" ?  "OldTestament" : "OldTestamentCS" }
    }
    
    public var title: String {
        get { return Translate.s("Old Testament", lang: lang) }
    }
    
    public var contentType: BookContentType = .text

    public var hasChapters = true
    
    public var hasDate = false
    public var date: Date = Date()

    public static let data: [[(String, String)]] = [
        [
            ("Genesis", "gen"),
            ("Exodus", "ex"),
            ("Leviticus","lev"),
            ("Numbers","num"),
            ("Deuteronomy","deut"),
            ],
        [
            ("Joshua","josh"),
            ("Judges","judg"),
            ("Ruth","ruth"),
            ("1 Samuel","1sam"),
            ("2 Samuel","2sam"),
            ("1 Kings","1kings"),
            ("2 Kings","2kings"),
            ("1 Chronicles","1chron"),
            ("2 Chronicles","2chron"),
            ("Ezra","ezra"),
            ("Nehemiah","neh"),
            ("Esther","esther"),
            ],
        [
            ("Job","job"),
            ("Psalms","ps"),
            ("Proverbs","prov"),
            ("Ecclesiastes","eccles"),
            ("Song of Solomon","song"),
            ],
        
        [
            ("Isaiah","isa"),
            ("Jeremiah","jer"),
            ("Lamentations","lam"),
            ("Ezekiel","ezek"),
            ("Daniel","dan"),
            ("Hosea","hos"),
            ("Joel","joel"),
            ("Amos","amos"),
            ("Obadiah","obad"),
            ("Jonah","jon"),
            ("Micah","mic"),
            ("Nahum","nahum"),
            ("Habakkuk","hab"),
            ("Zephaniah","zeph"),
            ("Haggai","hag"),
            ("Zechariah","zech"),
            ("Malachi","mal"),
            ]
    ]
    
    public init(lang: String) {
        self.lang = lang
    }
    
    public func getSections() -> [String] {
        return ["Five Books of Moses", "Historical books", "Wisdom books", "Prophets books"]
            .map { return Translate.s($0, lang: lang) }
    }
    
    public func getItems(_ section: Int) -> [String] {
        return OldTestamentModel.data[section]
            .map { return Translate.s($0.0, lang: lang) }
    }
    
    public func getNumChapters(_ index: IndexPath) -> Int {
        return numberOfChapters(OldTestamentModel.data[index.section][index.row].1)
    }

    public func getComment(commentId: Int) -> String? { return nil }
    
    public func getBookmarkName(_ bookmark: String) -> String {
        let comp = bookmark.components(separatedBy: "_")
        guard comp[0] == code else { return "" }
        
        let section = Int(comp[1])!
        let row = Int(comp[2])!
        let chapter = Int(comp[3])!
        
        let header = (OldTestamentModel.data[section][row].1 == "ps")
            ? Translate.s("Kathisma %@", lang: lang)
            : Translate.s("Chapter %@", lang: lang)
        
        let chapterTitle = String(format: header, Translate.stringFromNumber(chapter+1)).lowercased()
        
        return "\(title) - " + Translate.s(OldTestamentModel.data[section][row].0, lang: lang) + ", \(chapterTitle)"
    }
    
    public func getTitle(at pos: BookPosition) -> String? {
        guard let index = pos.index, let chapter = pos.chapter else { return nil }
        
        let header = (OldTestamentModel.data[index.section][index.row].1 == "ps")
            ? Translate.s("Kathisma %@", lang: lang)
            : Translate.s("Chapter %@", lang: lang)
        
        let chapterTitle = String(format: header, Translate.stringFromNumber(chapter+1))
       
        return chapterTitle
    }
    
    public func getContent(at pos: BookPosition) -> Any? {
        guard let index = pos.index, let chapter = pos.chapter else { return nil }
        let code =  OldTestamentModel.data[index.section][index.row].1
        return getChapter(code, chapter+1)
    }
    
    public func getBookmark(at pos: BookPosition) -> String? {
        guard let index = pos.index, let chapter = pos.chapter else { return "" }
        return "\(code)_\(index.section)_\(index.row)_\(chapter)"
    }
    
    public func getNextSection(at pos: BookPosition) -> BookPosition? {
        guard let index = pos.index, let chapter = pos.chapter else { return nil }

        let numChapters = numberOfChapters(OldTestamentModel.data[index.section][index.row].1)
        if chapter < numChapters-1 {
            return BookPosition(index: index, chapter: chapter+1)
        } else {
            return nil
        }
        
    }
    
    public func getPrevSection(at pos: BookPosition) -> BookPosition? {
        guard let index = pos.index, let chapter = pos.chapter else { return nil }

        if chapter > 0 {
            return BookPosition(index: index, chapter: chapter-1)
        } else {
            return nil
        }
    }
}

public class NewTestamentModel : BookModel, BibleModel {
    public var lang: String
    
    public var code : String {
        get { return lang == "ru" ?  "NewTestament" : "NewTestamentCS" }
    }
    
    public var title: String {
        get { return Translate.s("New Testament", lang: lang) }
    }
    
    public var contentType: BookContentType = .text

    public var hasChapters = true

    public var hasDate = false
    public var date: Date = Date()
    
    public static let data: [[(String, String)]] = [
        [
            ("Gospel of St Matthew", "matthew"),
            ("Gospel of St Mark", "mark"),
            ("Gospel of St Luke", "luke"),
            ("Gospel of St John", "john"),
            ("Acts of the Apostles", "acts"),
            ],
        [
            ("General Epistle of James", "james"),
            ("1st Epistle General of Peter", "1pet"),
            ("2nd General Epistle of Peter", "2pet"),
            ("1st Epistle General of John", "1john"),
            ("2nd Epistle General of John", "2john"),
            ("3rd Epistle General of John", "3john"),
            ("General Epistle of Jude", "jude"),
            ],
        [
            ("Epistle of St Paul to Romans", "rom"),
            ("1st Epistle of St Paul to Corinthians", "1cor"),
            ("2nd Epistle of St Paul to Corinthians", "2cor"),
            ("Epistle of St Paul to Galatians", "gal"),
            ("Epistle of St Paul to Ephesians", "ephes"),
            ("Epistle of St Paul to Philippians", "phil"),
            ("Epistle of St Paul to Colossians", "col"),
            ("1st Epistle of St Paul Thessalonians", "1thess"),
            ("2nd Epistle of St Paul Thessalonians", "2thess"),
            ("1st Epistle of St Paul to Timothy", "1tim"),
            ("2nd Epistle of St Paul to Timothy", "2tim"),
            ("Epistle of St Paul to Titus", "tit"),
            ("Epistle of St Paul to Philemon", "philem"),
            ("Epistle of St Paul to Hebrews", "heb"),
            ],
        [
            ("Revelation of St John the Devine", "rev")
        ]
    ]
    
    public init(lang: String) {
        self.lang = lang
    }
        
    public func getSections() -> [String] {
        return ["Four Gospels and Acts", "Catholic Epistles", "Epistles of Paul", "Apocalypse"]
            .map { return Translate.s($0, lang: lang) }
    }
    
    public func getItems(_ section: Int) -> [String] {
        return NewTestamentModel.data[section]
            .map { return  Translate.s($0.0, lang: lang) }
    }
    
    public func getNumChapters(_ index: IndexPath) -> Int {
        return numberOfChapters(NewTestamentModel.data[index.section][index.row].1)
    }
    
    public func getComment(commentId: Int) -> String? { return nil }
    
    public func getBookmarkName(_ bookmark: String) -> String {
        let comp = bookmark.components(separatedBy: "_")
        guard comp[0] == code else { return "" }
        
        let section = Int(comp[1])!
        let row = Int(comp[2])!
        let chapter = Int(comp[3])!
        
        let chapterTitle = String(format: Translate.s("Chapter %@", lang: lang), Translate.stringFromNumber(chapter+1)).lowercased()
        
        return "\(title) - " + Translate.s(NewTestamentModel.data[section][row].0, lang: lang) + ", \(chapterTitle)"
    }
    
    public func getTitle(at pos: BookPosition) -> String? {
        guard let chapter = pos.chapter else { return nil }
        let chapterTitle = String(format: Translate.s("Chapter %@", lang: lang), Translate.stringFromNumber(chapter+1))
       
        return chapterTitle
    }
        
    public func getContent(at pos: BookPosition) -> Any? {
        guard let index = pos.index, let chapter = pos.chapter else { return nil }

        let code =  NewTestamentModel.data[index.section][index.row].1
        return getChapter(code, chapter+1)
    }
    
    public func getBookmark(at pos: BookPosition) -> String? {
        guard let index = pos.index, let chapter = pos.chapter else { return "" }
        return "\(code)_\(index.section)_\(index.row)_\(chapter)"
    }
    
    public func getNextSection(at pos: BookPosition) -> BookPosition? {
        guard let index = pos.index, let chapter = pos.chapter else { return nil }

        let numChapters = numberOfChapters(NewTestamentModel.data[index.section][index.row].1)
        if chapter < numChapters-1 {
            return BookPosition(index: index, chapter: chapter+1)
        } else {
            return nil
        }
    }
    
    public func getPrevSection(at pos: BookPosition) -> BookPosition? {
        guard let index = pos.index, let chapter = pos.chapter else { return nil }

        if chapter > 0 {
            return BookPosition(index: index, chapter: chapter-1)
        } else {
            return nil
        }
    }
}

