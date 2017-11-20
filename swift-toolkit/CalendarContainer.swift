//
//  CalendarContainer.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 12/20/15.
//  Copyright © 2015 Alexey Smirnov. All rights reserved.
//

import UIKit

class CalendarNavigation: UINavigationController, PopupContentViewController {
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            return CGSize(width: 300, height: 350)

        } else {
            return CGSize(width: 500, height: 530)
        }
    }
}

public class CalendarContainer: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dates = [Date]()
    var cellReuseIdentifier : String! 
    var cellNibName : String!
    
    public static func show(inVC: UIViewController, cellReuseIdentifier: String, cellNibName: String, leftButton: UIBarButtonItem? = nil, rightButton: UIBarButtonItem? = nil) -> PopupController {
        let bundle = Bundle(identifier: "com.rlc.swift-toolkit")

        let container = UIViewController.named("CalendarContainer", bundle: bundle) as! CalendarNavigation
        let calendar = container.topViewController as! CalendarContainer
        calendar.cellNibName = cellNibName
        calendar.cellReuseIdentifier = cellReuseIdentifier
        calendar.navigationItem.leftBarButtonItem = leftButton
        calendar.navigationItem.rightBarButtonItem = rightButton
        
        container.navigationBar.barTintColor = UIColor(hex: "#FFEBCD")
        container.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let popup = PopupController
            .create(inVC)
            .customize(
                [
                    .animation(.fadeIn),
                    .layout(.center),
                    .backgroundStyle(.blackFilter(alpha: 0.7))
                ]
            )
        
        popup.show(container)
        return popup
    }
        
    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(hex: "#FFEBCD")
        collectionView.backgroundColor = UIColor.clear
        
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            collectionView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
            resizeCalendar(300, 300)
            
        } else {
            collectionView.frame = CGRect(x: 0, y: 0, width: 500, height: 500)
            resizeCalendar(500, 500)
        }
        
        view.setNeedsLayout()
        
        let currentDate: Date = DateComponents(date: Date()).toDate()
        setTitle(fromDate: currentDate)
        dates = [currentDate-1.months, currentDate, currentDate+1.months]
        
        collectionView.register(CalendarViewCell.self, forCellWithReuseIdentifier: CalendarViewCell.cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            layout.itemSize = CGSize(width: 300, height: 300)
        } else {
            layout.itemSize = CGSize(width: 500, height: 500)
        }
        
        CalendarContainer.generateLabels(view)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .left, animated: false)

    }
    
    func setTitle(fromDate date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        formatter.locale = Locale(identifier: "ru")

        title = formatter.string(from: date).capitalizingFirstLetter()
    }
    
    func resizeCalendar(_ width: Int, _ height: Int) {
        collectionView.constraints.forEach { con in
            if con.identifier == "calendar-width" {
                con.constant = CGFloat(width)
                
            } else if con.identifier == "calendar-height" {
                con.constant = CGFloat(height)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarViewCell.cellId, for: indexPath) as! CalendarViewCell
        cell.cellNibName = cellNibName
        cell.cellReuseIdentifier = cellReuseIdentifier
        
        cell.currentDate = dates[indexPath.row]
        
        return cell
    }

    func adjustView(_ scrollView: UIScrollView) {
        let contentOffsetWhenFullyScrolledRight = collectionView.frame.size.width * CGFloat(dates.count - 1)
        var current = dates[1]
        
        if scrollView.contentOffset.x == 0 {
            current = dates[0]
        } else if scrollView.contentOffset.x == contentOffsetWhenFullyScrolledRight {
            current = dates[2]
        }
        
        setTitle(fromDate: current)
        
        collectionView.performBatchUpdates({
            self.dates[0] = current-1.months
            self.dates[1] = current
            self.dates[2] = current+1.months
            
        }, completion: { _ in
            UIView.setAnimationsEnabled(false)
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .left, animated: false)
            UIView.setAnimationsEnabled(true)
        })
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustView(scrollView)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            adjustView(scrollView)
        }
    }
    
    public static func generateLabels(_ view: UIView, standalone : Bool = false, textColor : UIColor? = nil, fontSize : CGFloat? = nil) {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        formatter.locale = Locale(identifier: "ru")
        
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ru")
        
        var dayLabel = [String]()
        
        if standalone {
            dayLabel = formatter.veryShortStandaloneWeekdaySymbols as [String]
            
        } else {
            dayLabel = formatter.veryShortWeekdaySymbols as [String]
        }
        
        for index in cal.firstWeekday...7 {
            if let label = view.viewWithTag(index-cal.firstWeekday+1) as? UILabel {
                label.text = dayLabel[index-1]
            }
        }
        
        if cal.firstWeekday > 1 {
            for index in 1...cal.firstWeekday-1 {
                if let label = view.viewWithTag(8-cal.firstWeekday+index) as? UILabel {
                    label.text = dayLabel[index-1]
                }
            }
        }
        
        if let color = textColor,
            let size = fontSize {
            for index in 1...7 {
                if let label = view.viewWithTag(index) as? UILabel {
                    label.textColor =  color
                    label.font = UIFont.systemFont(ofSize: size)
                }
            }
        }
    }

}
