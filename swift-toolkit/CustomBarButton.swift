//
//  CustomBarButton.swift
//  swift-toolkit
//
//  Created by Alexey Smirnov on 11/16/18.
//  Copyright © 2018 Alexey Smirnov. All rights reserved.
//

import UIKit

public class CustomBarButton : UIBarButtonItem {
    var iv : UIImageView!
    
    public convenience init(image: UIImage, target: AnyObject, btnHandler: Selector) {
        let resizedImage = image.resize(CGSize(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(btnImage: resizedImage, target: target, btnHandler: btnHandler)
        
        if #available(iOS 11, *) {
            self.init(customView: WrapperView(imageView))
        } else {
            self.init(customView: imageView)
        }
        
        iv = imageView
    }
}

