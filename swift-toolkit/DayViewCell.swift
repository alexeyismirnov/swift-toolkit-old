//
//  DayViewCell.swift
//  swift-toolkit
//
//  Created by Alexey Smirnov on 8/2/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import UIKit

public class DayViewCell: LabelViewCell {
    public var currentDate : Date?

    func configureCell(date: Date?, fontSize: CGFloat, textColor: UIColor, selectedDate: Date?) {
        regularLayout()
        
        contentView.backgroundColor =  UIColor.clear
        title.backgroundColor =  UIColor.clear
        
        currentDate = date
        
        guard let date = date else { title.text = ""; return }
        
        title.text = String(format: "%d", date.day)
        
        if let _ = Cal.getGreatFeast(date) {
            title.font = UIFont.boldSystemFont(ofSize: fontSize)
        } else {
            title.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        let fasting = FastingModel.fasting(forDate: date)
        
        if let _ = Cal.getGreatFeast(date) {
            title.textColor = .red
            
        } else if fasting.type == .noFast || fasting.type == .noFastMonastic {
            title.textColor = textColor
            
        } else {
            title.textColor = .black
        }
        
        contentView.backgroundColor = fasting.color
        
        if date == selectedDate {
            NSLayoutConstraint.deactivate(con)

            con = [
                title.centerXAnchor.constraint(equalTo: centerXAnchor),
                title.centerYAnchor.constraint(equalTo: centerYAnchor),
                title.widthAnchor.constraint(equalToConstant: fontSize + 15.0),
                title.heightAnchor.constraint(equalToConstant: fontSize + 15.0),

            ]
            
            NSLayoutConstraint.activate(con)
            
            title.layer.cornerRadius = fontSize
            title.backgroundColor = .red
            title.textColor = .white
        }
        
    }
}
