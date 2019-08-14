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
        
        heightAnchor.constraint(equalToConstant: 45.0).isActive = true
        
        title = RWLabel()
        title.numberOfLines = 0
        title.preferredMaxLayoutWidth = 310

        title.font = UIFont.systemFont(ofSize: 17)
        title.adjustsFontSizeToFitWidth = false
        title.clipsToBounds = true
        
        contentView.addSubview(title)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10.0).isActive = true
        title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10.0).isActive = true
        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0).isActive = true
        title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 5.0).isActive = true
    }
}

extension TextCell: ReusableView {}
