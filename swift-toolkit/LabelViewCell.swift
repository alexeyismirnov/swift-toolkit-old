//
//  LabelViewCell.swift
//  ponomar
//
//  Created by Alexey Smirnov on 7/24/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import UIKit

public class LabelViewCell: UICollectionViewCell {
    public var title: UILabel!
    var con = [NSLayoutConstraint]()
    
    func regularLayout() {
        NSLayoutConstraint.deactivate(con)

        con = [
            title.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(con)
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false

        title.numberOfLines = 1
        title.font = UIFont.systemFont(ofSize: Theme.defaultFontSize)
        title.textColor = Theme.textColor
        title.adjustsFontSizeToFitWidth = false
        title.clipsToBounds = true
        title.textAlignment = .center
        title.baselineAdjustment = .alignCenters
        
        addSubview(title)
        
        regularLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LabelViewCell: ReusableView {}