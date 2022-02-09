//
//  SaintModel.swift
//  swift-toolkit
//
//  Created by Alexey Smirnov on 7/29/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import Foundation
import Squeal

public struct SaintModel {
    static var databases = [String: Database]()
    
    static public func saints(_ date: Date) -> [Saint] {
        var saints = [Saint]()
        let cal = Cal2.fromDate(date)
        
        if (cal.isLeapYear) {
            switch date {
            case cal.leapStart ..< cal.leapEnd:
                saints = saintsData(date+1.days)
                break
                
            case cal.leapEnd:
                saints = saintsData(Date(29, 2, cal.year))
                break
                
            default:
                saints = saintsData(date)
            }
            
        } else {
            saints = saintsData(date)
            if (date == cal.leapEnd) {
                saints += saintsData(Date(29, 2, 2000))
            }
        }
        
        return saints
    }
    
    static func getDatabase(_ filename: String) -> Database {
        let url = AppGroup.url.appendingPathComponent(filename)
        let db = try! Database(path: url.path)

        databases[filename] = db
        return db
    }
    
    private static func saintsData(_ date: Date) -> [Saint] {
        var saints = [Saint]()
        
        let dc = DateComponents(date: date)

        let filename = String(format: "saints_%02d_%@.sqlite", dc.month!, Translate.language)
        let db = databases[filename] ?? getDatabase(filename)

        let saintsDB = try! db.selectFrom("saints", whereExpr:"day=\(dc.day!)", orderBy: "-typikon") { ["name": $0["name"], "typikon": $0["typikon"]] }
        
        for line in saintsDB {
            let name = line["name"] as! String
            let typikon = FeastType(rawValue: Int(line["typikon"] as! Int64))
            saints.append(Saint(name,typikon!))
        }
        
        return saints
    }
    
}
