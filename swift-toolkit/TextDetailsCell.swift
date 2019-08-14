//
//  TextDetailsCell.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 06.04.15.
//  Copyright (c) 2015 Alexey Smirnov. All rights reserved.
//

import UIKit

public class TextDetailsCell : UITableViewCell {
    public var title: RWLabel!
    public var subtitle: RWLabel!
    
    var con : [NSLayoutConstraint]!

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLabel(fontSize: CGFloat) -> RWLabel {
        let label = RWLabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 310
        
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
    
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        title = createLabel(fontSize: 20)
        subtitle = createLabel(fontSize: 17)

        contentView.addSubview(title)
        contentView.addSubview(subtitle)

        con = [
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0.0),
            title.bottomAnchor.constraint(equalTo: subtitle.topAnchor),
            
            subtitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0),
            subtitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0),
            subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
        ]
        
        NSLayoutConstraint.activate(con)
    }
    
}

extension TextDetailsCell: ReusableView {}
