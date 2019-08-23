//
//  BookPageText.swift
//  ponomar
//
//  Created by Alexey Smirnov on 5/16/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import UIKit

public class BookPageText: BookPage {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTheme), name: .themeChangedNotification, object: nil)
        
        reloadTheme()
        createNavigationButtons()
        updateNavigationButtons()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if contentView1 != nil {
            (contentView1 as! UITextView).setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc override func reloadTheme() {
        let toolkit = Bundle(identifier: "com.rlc.swift-toolkit")
        
        if let bgColor = Theme.mainColor {
            view.backgroundColor =  bgColor
            
        } else {
            view.backgroundColor = UIColor(patternImage: UIImage(background: "bg3.jpg", inView: view, bundle: toolkit))
        }
        
        fontSize = prefs.integer(forKey: "fontSize")
        
        if (contentView1 != nil) {
            contentView1.removeFromSuperview()
            NSLayoutConstraint.deactivate(con)
        }
        
        contentView1 = createContentView(pos)
        
        con = generateConstraints(forView: contentView1, leading: 10, trailing: -10)
        NSLayoutConstraint.activate(con)
    }
    
    override func createContentView(_ pos: BookPosition) -> UIView {
        let navbarHeight = (navigationController?.navigationBar.frame.height ?? 0.0) + UIApplication.shared.statusBarFrame.height
        let tabbarHeight = (tabBarController?.tabBar.frame.size.height ?? 0.0)
        
        let frame = CGRect(origin: CGPoint(x: 0, y: navbarHeight),
                           size: CGSize(width: view.frame.width, height: view.frame.height - navbarHeight - tabbarHeight))
        
        let textView = UITextView(frame: frame)
        
        // textView.translatesAutoresizingMaskIntoConstraints = false
        
        // textView.font = UIFont(name: "TimesNewRomanPSMT", size: CGFloat(fontSize))!
        // textView.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        
        view.addSubview(textView)
        
        textView.textColor = Theme.textColor

        textView.attributedText = model.getContent(at: pos) as? NSAttributedString
        textView.font = UIFont(name: "PingFangSC-Regular", size: CGFloat(fontSize))!
        
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.isEditable = false
        textView.showsVerticalScrollIndicator = true
        
        textView.scrollRangeToVisible(NSRange(location:0, length:0))
        
        return textView
    }
    

}
