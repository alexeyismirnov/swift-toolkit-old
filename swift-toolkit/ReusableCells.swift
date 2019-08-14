//
//  ReusableCells.swift
//  swift-toolkit
//
//  Created by Alexey Smirnov on 8/14/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import UIKit

public class RWLabel : UILabel {
    override public var bounds : CGRect {
        didSet {
            if numberOfLines == 0 && bounds.size.width != preferredMaxLayoutWidth {
                preferredMaxLayoutWidth = self.bounds.size.width
                DispatchQueue.main.async(execute: {
                    self.setNeedsUpdateConstraints()
                    self.setNeedsDisplay()
                    
                })
            }
        }
    }
}

public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        register(T.self)
        return dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    }
    
}

public extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        register(T.self)
        return dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as! T
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T where T: ReusableView {
        register(T.self)
        return dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as! T
    }
}

public protocol ResizableTableViewCells : UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView! { get set }
}

public extension ResizableTableViewCells where Self: UIViewController {
    func createTableView(style: UITableView.Style) {
        automaticallyAdjustsScrollViewInsets = false
        
        tableView = UITableView(frame: .zero, style: style)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        fullScreen(view: tableView)
    }
    
    func getTextCell(_ title: String) -> TextCell {
        let newCell: TextCell = tableView.dequeueReusableCell()
        newCell.accessoryType = .none
        newCell.backgroundColor = .clear
        newCell.title.textColor =  Theme.textColor
        newCell.title.text = title
        
        return newCell
    }
    
    func getTextDetailsCell(title: String, subtitle: String) -> TextDetailsCell {
        let newCell:TextDetailsCell = tableView.dequeueReusableCell()
        newCell.accessoryType = .none
        newCell.backgroundColor = .clear
        
        newCell.title.textColor = Theme.textColor
        newCell.subtitle.textColor = Theme.secondaryColor
        
        newCell.title.text = title
        newCell.subtitle.text = subtitle
        
        return newCell
    }
    
    func getSimpleCell(_ title: String) -> UITableViewCell {
        let newCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        newCell.accessoryType = .none
        newCell.backgroundColor = .clear
        newCell.textLabel!.textColor = Theme.textColor
        newCell.textLabel!.text = title
        
        return newCell
    }
    
    func getCell<T: UITableViewCell>() -> T  where T: ReusableView  {
        let newCell:T  = tableView.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as! T
        newCell.accessoryType = .none
        newCell.backgroundColor = .clear
            
        return newCell
    }
    
    func calculateHeightForCell(_ cell: UITableViewCell) -> CGFloat {
        cell.bounds = CGRect(x: 0, y: 0, width: tableView.frame.width-1, height: cell.bounds.height)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size.height+1.0
    }
}

