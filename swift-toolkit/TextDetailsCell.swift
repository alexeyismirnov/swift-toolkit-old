//
//  TextDetailsCell.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 06.04.15.
//  Copyright (c) 2015 Alexey Smirnov. All rights reserved.
//

import UIKit

public class TextDetailsCell : UITableViewCell {
    @IBOutlet public weak var title: RWLabel!
    @IBOutlet public weak var subtitle: RWLabel!
}

extension TextDetailsCell: ReusableView {}
