//
//  WeekCalendar.swift
//  ponomar
//
//  Created by Alexey Smirnov on 11/6/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import UIKit

public class WeekCalendar: UIViewControllerAnimated, ResizableTableViewCells {
    public var tableView: UITableView!
    let toolkit = Bundle(identifier: "com.rlc.swift-toolkit")
    var appeared = false

    public var currentDate: Date = {
        // this is done to remove time component from date
        return DateComponents(date: Date()).toDate()
    }()
    
    override public func viewControllerCurrent() -> UIViewController {
        return WeekCalendar(currentDate)
    }
    
    override public func viewControllerForward() -> UIViewController {
        return WeekCalendar(currentDate + 7.days)
    }
    
    override public func viewControllerBackward() -> UIViewController {
        return WeekCalendar(currentDate - 7.days)
    }
    
    public init(_ date: Date) {
        self.currentDate = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavbar()
        createTableView(style: .grouped)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        appeared = true
        tableView.reloadData()
    }
    
    func setupNavbar() {
        let toolkit = Bundle(identifier: "com.rlc.swift-toolkit")
        
        let backButton = UIBarButtonItem(image: UIImage(named: "close", in: toolkit), style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = backButton
        
        let button_info = UIBarButtonItem(image: UIImage(named: "help", in: toolkit), style: .plain, target: self, action: #selector(showInfo))
        navigationItem.rightBarButtonItem = button_info

        navigationController?.makeTransparent()
        
        if let bgColor = Theme.mainColor {
            view.backgroundColor =  bgColor
            
        } else {
            view.backgroundColor = UIColor(patternImage: UIImage(background: "bg3.jpg", inView: view,  bundle: Bundle(identifier: "com.rlc.swift-toolkit")))
        }
    }
    
    @objc func showInfo() {        
        showPopup(FastingLegendTableView())
    }
    
    @objc func close() {
        dismiss(animated: true, completion: { })
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 7
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let title = Cal.getWeekDescription(currentDate)
            let subtitle = Cal.getToneDescription(currentDate)
            
            return getTextDetailsCell(title: title ?? "", subtitle: subtitle ?? "")
            
        } else {
            let date = currentDate + (indexPath.row).days
            let cell: WeekCalendarCell = tableView.dequeueReusableCell()
            
            var content = [(FeastType, String)]()
            
            if (appeared) {
                content.append(contentsOf:
                    Cal.getDayDescription(date).filter({ !$0.1.contains(Translate.s("Forefeast")) && !$0.1.contains(Translate.s("Afterfeast")) }))
                
                content.append(contentsOf: SaintModel.saints(date))
            }
            
            cell.configureCell(date: date, content: content, cellWidth: tableView.frame.width, appeared: appeared)
            
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (!appeared) { return 60.0 }
        
        let cell : UITableViewCell = self.tableView(tableView, cellForRowAt: indexPath)
        return calculateHeightForCell(cell)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        
        let date = currentDate + (indexPath.row).days
        let userInfo:[String: Date] = ["date": date]
        
        NotificationCenter.default.post(name: .dateChangedNotification, object: nil, userInfo: userInfo)

        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: { })
        }
    }
}

