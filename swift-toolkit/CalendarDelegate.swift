//
//  CalendarDataSource.swift
//  saints
//
//  Created by Alexey Smirnov on 11/4/17.
//  Copyright © 2017 Alexey Smirnov. All rights reserved.
//

import UIKit

public class CalendarDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var selectedDate: Date?
    public var cellReuseIdentifier : String!
    
    public var currentDate: Date! {
        didSet {
            let monthStart = Date(1, currentDate.month, currentDate.year)
            var cal = Calendar.current
            cal.locale = Locale(identifier: "ru")
            startGap = (monthStart.weekday < cal.firstWeekday) ? 7 - (cal.firstWeekday-monthStart.weekday) : monthStart.weekday - cal.firstWeekday
        }
    }
    
    private var startGap: Int!

    @objc public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (currentDate == nil) {
            return 0
        }
        
        let range = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: currentDate)
        return range.length + startGap
    }
    
    @objc public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! CellWithDate
        var curDate : Date? = nil
        
        if indexPath.row >= startGap {
            let dayIndex = indexPath.row + 1 - startGap
            curDate = Date(dayIndex, currentDate.month, currentDate.year)
        }
        
        cell.configureCell(date: curDate)
        
        return cell as! UICollectionViewCell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width-1) / 7.0
        return CGSize(width: cellWidth, height: cellWidth)
    }

}


