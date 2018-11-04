//
//  TextCell.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 27.03.15.
//  Copyright (c) 2015 Alexey Smirnov. All rights reserved.
//

import UIKit

public class TextCell : ConfigurableCell {
    override public class var cellId: String {
        get { return "TextCell" }
    }
    
    @IBOutlet weak public var title: RWLabel!
    
}
