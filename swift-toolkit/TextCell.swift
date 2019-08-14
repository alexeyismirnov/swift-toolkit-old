//
//  TextCell.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 27.03.15.
//  Copyright (c) 2015 Alexey Smirnov. All rights reserved.
//

import UIKit

public class TextCell : UITableViewCell  {
    public var title: RWLabel!
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        title = RWLabel()
        title.numberOfLines = 0
        
        title.font = UIFont.systemFont(ofSize: Theme.defaultFontSize)
        title.textColor = Theme.textColor
        title.adjustsFontSizeToFitWidth = false
        title.clipsToBounds = true
        title.preferredMaxLayoutWidth = 310
        
        addSubview(title)
        //fullScreen(view: title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 10.0).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: 10.0).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 0.0).isActive = true
        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5.0).isActive = true
    }
}

extension TextCell: ReusableView {}
