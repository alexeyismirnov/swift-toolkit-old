//
//  Theme.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 4/12/17.
//  Copyright © 2017 Alexey Smirnov. All rights reserved.
//

import UIKit
import Chameleon

public enum AppTheme {
    case Default
    case Chameleon(color: UIColor)
}

public enum AppStyle: Int {
    case Default=0, Light, Dark
}

public struct Theme {
    public static var textColor: UIColor!
    public static var mainColor : UIColor?
    public static var secondaryColor : UIColor!
    public static let defaultFontSize = CGFloat(UIDevice.current.userInterfaceIdiom == .phone ? 16.0 : 18.0)
    
    public static func set(_ t: AppTheme) {
        switch t {
        case .Default:
            mainColor = nil
            textColor = UIColor.black
            secondaryColor = UIColor.init(hex: "#804000")
            
            UINavigationBar.appearance().barTintColor = UIColor(red: 255/255.0, green: 233/255.0, blue: 210/255.0, alpha: 1.0)
            UINavigationBar.appearance().tintColor = .blue
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
            
            UIBarButtonItem.appearance().tintColor = .blue
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .blue
            UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .blue
            
            UITabBar.appearance().barTintColor = UIColor(red: 255/255.0, green: 233/255.0, blue: 210/255.0, alpha: 1.0)
            UITabBar.appearance().tintColor = UIColor.red

        case .Chameleon(let color):
            mainColor = color
            textColor = ContrastColorOf(mainColor!, returnFlat: false)
            secondaryColor = textColor?.flatten()
            
            Chameleon.setGlobalThemeUsingPrimaryColor(mainColor, withSecondaryColor: secondaryColor, andContentStyle: .contrast)
            UITabBar.appearance().tintColor = secondaryColor
            
            UITabBar.appearance().barTintColor = UIColor(red: 255/255.0, green: 233/255.0, blue: 210/255.0, alpha: 1.0)
            UITabBar.appearance().tintColor = UIColor.red

        }
    }
    
}
