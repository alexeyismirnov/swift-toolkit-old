//
//  CalendarView.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 4/17/17.
//  Copyright © 2017 Alexey Smirnov. All rights reserved.
//

import UIKit

public let dateChangedNotification = "DATE_CHANGED"

public protocol CellWithDate {
    var currentDate : Date? { get }
    func configureCell(date : Date?)
}

class CalendarViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout {
    static let cellId = "CalendarCell"

    var collectionView: UICollectionView!
    var dataSource : CalendarDataSource!
    var cellReuseIdentifier : String! {
        didSet {
            collectionView.register(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellReuseIdentifier)
            dataSource.cellReuseIdentifier = cellReuseIdentifier
        }
    }
    var cellNibName : String!
    
    var currentDate: Date! {
        didSet {
            dataSource.currentDate = currentDate
            collectionView.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        let initialFrame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: initialFrame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear

        dataSource = CalendarDataSource()
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(doneWithDate(_:)))
        recognizer.numberOfTapsRequired = 1
        collectionView.addGestureRecognizer(recognizer)
        
        contentView.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width-1) / 7.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    @objc func doneWithDate(_ recognizer: UITapGestureRecognizer) {
        let loc = recognizer.location(in: collectionView)
        
        if  let path = collectionView.indexPathForItem(at: loc),
            let cell = collectionView.cellForItem(at: path) as? CellWithDate,
            let curDate = cell.currentDate {
            
                let userInfo:[String: Date] = ["date": curDate]
                NotificationCenter.default.post(name: Notification.Name(rawValue: dateChangedNotification), object: nil, userInfo: userInfo)
        }
    }
    
}
