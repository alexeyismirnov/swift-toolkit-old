//
//  SwifterSwift.swift
//  swift-toolkit
//
//  Created by Alexey Smirnov on 11/18/18.
//  Copyright © 2018 Alexey Smirnov. All rights reserved.
//

import Foundation

public extension String {
    public func colored(with color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: self).colored(with: color)
    }
}

public extension NSAttributedString {
    
    public var centered: NSAttributedString {
        let centerStyle = NSMutableParagraphStyle()
        centerStyle.alignment = .center
        
        return applying(attributes: [.paragraphStyle: centerStyle])
    }
    
    public func colored(with color: UIColor) -> NSAttributedString {
        return applying(attributes: [.foregroundColor: color])
    }
    
    public func systemFont(ofSize: CGFloat) -> NSAttributedString {
        return applying(attributes: [.font: UIFont.systemFont(ofSize: CGFloat(ofSize))])
    }
    
    public func boldFont(ofSize: CGFloat) -> NSAttributedString {
        return applying(attributes: [.font: UIFont.boldSystemFont(ofSize: CGFloat(ofSize))])
    }
    
    fileprivate func applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let copy = NSMutableAttributedString(attributedString: self)
        let range = (string as NSString).range(of: string)
        copy.addAttributes(attributes, range: range)
        
        return copy
    }
    
    public static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        lhs = string
    }
    
    public static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let string = NSMutableAttributedString(attributedString: lhs)
        string.append(rhs)
        return NSAttributedString(attributedString: string)
    }
    
    public static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }
    
    public static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
    
}
