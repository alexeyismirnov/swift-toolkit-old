//
//  WrapperView.swift
//  swift-toolkit
//
//  Created by Alexey Smirnov on 11/16/18.
//  Copyright © 2018 Alexey Smirnov. All rights reserved.
//

import UIKit

class WrapperView: UIView {
    let minimumSize: CGSize = CGSize(width: 70, height: 25)
    let underlyingView: UIView
    init(_ underlyingView: UIView) {
        self.underlyingView = underlyingView
        super.init(frame: underlyingView.bounds)
        
        underlyingView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underlyingView)
        
        NSLayoutConstraint.activate([
            underlyingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underlyingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underlyingView.topAnchor.constraint(equalTo: topAnchor),
            underlyingView.bottomAnchor.constraint(equalTo: bottomAnchor),
            heightAnchor.constraint(greaterThanOrEqualToConstant: minimumSize.height),
            widthAnchor.constraint(greaterThanOrEqualToConstant: minimumSize.width)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // ...
}

