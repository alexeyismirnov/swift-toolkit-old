//
//  SaintModel.swift
//  swift-toolkit
//
//  Created by Alexey Smirnov on 7/29/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import Foundation
import Squeal

public var groupId = ""
public var groupURL : URL!

struct SaintModel {
    static func saints(_ date: Date) -> [(FeastType, String)] {
        var saints = [(FeastType, String)]()
        
        Cal.setDate(date)
        
        if (Cal.isLeapYear) {
            switch date {
            case Cal.leapStart ..< Cal.leapEnd:
                saints = saintsData(date+1.days)
                break
                
            case Cal.leapEnd:
                saints = saintsData(Date(29, 2, Cal.currentYear))
                break
                
            default:
                saints = saintsData(date)
            }
            
        } else {
            saints = saintsData(date)
            if (date == Cal.leapEnd) {
                saints += saintsData(Date(29, 2, 2000))
            }
        }
        
        return saints
    }
    
    private static func saintsData(_ date: Date) -> [(FeastType, String)] {
        let dc = DateComponents(date: date)
        let filename = String(format: "saints_%02d_%@.sqlite", dc.month!, Translate.language)
        
        let dst = groupURL.appendingPathComponent(filename)
        let db = try! Database(path:dst.path)
        
        var saints = [(FeastType, String)]()
        let saintsDB = try! db.selectFrom("saints", whereExpr:"day=\(dc.day!)", orderBy: "-typikon") { ["name": $0["name"], "typikon": $0["typikon"]] }
        
        for line in saintsDB {
            let name = line["name"] as! String
            let typikon = FeastType(rawValue: Int(line["typikon"] as! Int64))
            saints.append((typikon!, name))
        }
        
        return saints
    }
    
}
