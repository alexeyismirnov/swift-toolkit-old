//
//  CalendarSelector2.swift
//  ponomar
//
//  Created by Alexey Smirnov on 10/4/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import UIKit

public extension Notification.Name {
    static let weeklyCalendarNotification = Notification.Name("SHOW_WEEKLY")
    static let monthlyCalendarNotification = Notification.Name("SHOW_MONTHLY")
    static let yearlyCalendarNotification = Notification.Name("SHOW_YEARLY")
}

public class CalendarSelector: UIViewController, ResizableTableViewCells, PopupContentViewController {
    public var tableView: UITableView!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
        
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#FFEBCD")
        
        createTableView(style: .grouped, isPopup: true)
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let notifications : [Notification.Name] = [.weeklyCalendarNotification, .monthlyCalendarNotification, .yearlyCalendarNotification]
        
        NotificationCenter.default.post(name: notifications[indexPath.row],
                                        object: nil,
                                        userInfo: nil)
        
        return nil
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Translate.s("Calendar")
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let names = ["Weekly", "Monthly", "Yearly"]
        
        let cell = getTextDetailsCell(title: Translate.s(names[indexPath.row]), subtitle: "")
        cell.title.textColor = .black
        cell.title.textAlignment = .center
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateHeightForCell(self.tableView(tableView, cellForRowAt: indexPath), minHeight: CGFloat(50))
    }
    
    public func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 200, height: 170)
    }
    
}
