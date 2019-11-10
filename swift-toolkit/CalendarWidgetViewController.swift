//
//  MainViewController.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 10/31/16.
//  Copyright © 2016 Alexey Smirnov. All rights reserved.
//

import UIKit
import NotificationCenter

open class CalendarWidgetViewController : UINavigationController, NCWidgetProviding {
    static let tk = Bundle(identifier: "com.rlc.swift-toolkit")
    
    static let size15 = CGSize(width: 15, height: 15)
    static let icon15x15 : [FeastType: UIImage] = [
        .noSign: UIImage(named: "nosign", in: tk)!.resize(size15),
        .sixVerse: UIImage(named: "sixverse", in: tk)!.resize(size15),
        .doxology: UIImage(named: "doxology", in: tk)!.resize(size15),
        .polyeleos: UIImage(named: "polyeleos", in: tk)!.resize(size15),
        .vigil: UIImage(named: "vigil", in: tk)!.resize(size15),
        .great: UIImage(named: "great", in: tk)!.resize(size15)
    ]
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        Translate.language = AppGroup.prefs.object(forKey: "language") as! String
        FastingModel.fastingLevel = FastingLevel(rawValue: AppGroup.prefs.integer(forKey: "fastingLevel"))

        isNavigationBarHidden = true

        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    public func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        var viewController : UIViewController!
        
        popViewController(animated: false)
        
        if activeDisplayMode == NCWidgetDisplayMode.compact {
            self.preferredContentSize = maxSize
            viewController = UIViewController.named("Compact", bundle: CalendarWidgetViewController.tk)
            
        } else if activeDisplayMode == NCWidgetDisplayMode.expanded {
            self.preferredContentSize = CGSize(width: 0.0, height: 350)
            viewController = UIViewController.named("Expanded", bundle: CalendarWidgetViewController.tk)
        }

        pushViewController(viewController, animated: false)
    }

    public func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    public func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    static func describe(saints: [(FeastType, String)], font: UIFont!, dark: Bool) -> NSAttributedString {
        let myString = NSMutableAttributedString(string: "")
        
        if let _ = Cal.feastIcon[saints[0].0] {
            let attachment = NSTextAttachment()
            attachment.image = CalendarWidgetViewController.icon15x15[saints[0].0]
            attachment.bounds = CGRect(x: 0.0, y: font.descender/2, width: attachment.image!.size.width, height: attachment.image!.size.height)
            
            myString.append(NSAttributedString(attachment: attachment))
        }
        
        var textColor:UIColor = dark ? .white : .black
        if (saints[0].0 == .great) { textColor = .red }

        myString.append(NSMutableAttributedString(string: saints[0].1,
                                                  attributes: [
                                                    .foregroundColor: textColor,
                                                    .font: font! ]))
        
        return myString
    }
    
}
