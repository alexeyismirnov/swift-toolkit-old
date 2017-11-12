//
//  CalendarDataSource.swift
//  saints
//
//  Created by Alexey Smirnov on 11/4/17.
//  Copyright © 2017 Alexey Smirnov. All rights reserved.
//

import UIKit

class CalendarDataSource: NSObject, UICollectionViewDataSource {
    var startGap: Int!
    var selectedDate: Date?
    var textSize : CGFloat?
    var cellReuseIdentifier : String!
    
    var cal: Calendar = {
        let c = Calendar.current
        return c
    }()
    
    var currentDate: Date! {
        didSet {
            let monthStart = Date(1, currentDate.month, currentDate.year)
            cal.locale = Locale(identifier: "ru")
            startGap = (monthStart.weekday < cal.firstWeekday) ? 7 - (cal.firstWeekday-monthStart.weekday) : monthStart.weekday - cal.firstWeekday
        }
    }

    @objc func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (currentDate == nil) {
            return 0
        }
        
        let range = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: currentDate)
        return range.length + startGap
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CellWithDate
        var curDate : Date? = nil
        
        if indexPath.row >= startGap {
            let dayIndex = indexPath.row + 1 - startGap
            curDate = Date(dayIndex, currentDate.month, currentDate.year)
        }
        
        cell.configureCell(date: curDate)
        
        return cell as! UICollectionViewCell
    }

}


