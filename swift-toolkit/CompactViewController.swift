//
//  CompactViewController.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 11/1/16.
//  Copyright © 2016 Alexey Smirnov. All rights reserved.
//

import UIKit

class CompactViewController: UIViewController {
    var formatter: DateFormatter = {
        var formatter = DateFormatter()
        formatter.timeStyle = .none
        switch Translate.language {
        case "ru":
            formatter.dateFormat = "cccc d MMMM yyyy г."
            break
        default:
            formatter.dateStyle = .full
        }
        
        return formatter
    }()

    var cal: Cal!
    var currentDate: Date!  {
        didSet {
            cal = Cal.fromDate(currentDate)
        }
    }
    
    var dark = false
    
    @IBOutlet weak var dayInfo: UITextView!
    @IBOutlet weak var buttonUp: UIButton!
    @IBOutlet weak var buttonDown: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentDate = DateComponents(date: Date()).toDate()
        
        if #available(iOS 12.0, *) {
            dark = (traitCollection.userInterfaceStyle == .dark)
        }
        
        let toolkit = Bundle(identifier: "com.rlc.swift-toolkit")
        
        let image1 = UIImage(named: "fat-up", in: toolkit)!.withRenderingMode(.alwaysTemplate)
        buttonUp.setImage(image1, for: UIControl.State())
        
        let image2 = UIImage(named: "fat-down", in: toolkit)!.withRenderingMode(.alwaysTemplate)
        buttonDown.setImage(image2, for: UIControl.State())
        
        buttonUp.imageView?.tintColor =  dark ? .white : .darkGray
        buttonDown.imageView?.tintColor = dark ? .white : .darkGray
        
        formatter.locale = Translate.locale
        
        let recognizer = UITapGestureRecognizer(target: self, action:#selector(self.onTapLabel(_:)))
        recognizer.numberOfTapsRequired = 1
        dayInfo.addGestureRecognizer(recognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)    
        dayInfo.attributedText = describe()
    }
    
    func describe() -> NSAttributedString {
        let result = NSMutableAttributedString(string: "")
        
        var fontSize : CGFloat

        if ["iPhone 5", "iPhone 5s", "iPhone 5c", "iPhone 6", "iPhone 6s", "iPhone 7", "iPhone 8",
            "iPhone SE", "iPhone X"].contains(UIDevice.modelName) {
            fontSize = 15
        } else {
            fontSize = 18
        }

        let fontRegular = UIFont.systemFont(ofSize: fontSize)
        let fontBold = UIFont.systemFont(ofSize: fontSize).withTraits(.traitBold)
        let fontItalic = UIFont.systemFont(ofSize: fontSize).withTraits(.traitItalic)

        var descr = formatter.string(from: currentDate).capitalizingFirstLetter() + " "
        
        let s1 = NSAttributedString(string: descr, attributes: [.font: fontBold])
        result.append(s1)

        if let weekDescription = cal.getWeekDescription(currentDate) {
            descr = weekDescription
            let s2 = NSAttributedString(string: descr, attributes: [.font: fontRegular])
            result.append(s2)
        }
        
        if let toneDescription = cal.getToneDescription(currentDate) {
            descr = "; " + toneDescription
            let s3 = NSAttributedString(string: descr, attributes: [.font: fontRegular])
            result.append(s3)
        }
        
        let fasting = ChurchFasting.forDate(currentDate) 
        descr = ". " + fasting.descr

        let s4 = NSAttributedString(string: descr, attributes: [.font: fontItalic])
        result.append(s4)
        
        let saints = SaintModel.saints(currentDate)
        let day = cal.getDayDescription(currentDate)
        let feasts = (saints+day).sorted { $0.type.rawValue > $1.type.rawValue }
        
        result.append(NSAttributedString(string: "\n"))
        result.append(CalendarWidgetViewController.describe(saints: feasts, font: fontRegular, dark: dark))

        return result.colored(with: dark ? .white : .black)
    }
    
    @IBAction func prevDay(_ sender: Any) {
        Animation.swipe(orientation: .vertical,
                        direction: .negative,
                        inView: view,
                        update: {
                            self.currentDate = self.currentDate - 1.days
                            self.dayInfo.attributedText = self.describe()
        })
        
    }
    
    @IBAction func nextDay(_ sender: Any) {
        Animation.swipe(orientation: .vertical,
                        direction: .positive,
                        inView: view,
                        update: {
                            self.currentDate = self.currentDate + 1.days
                            self.dayInfo.attributedText = self.describe()
        })
    }
    
    @IBAction func onTapLabel(_ sender: AnyObject) {
        let seconds = currentDate.timeIntervalSince1970
        let scheme = Translate.language == "ru" ? "ponomar-ru" : "ponomar"
        let url = URL(string: "\(scheme)://open?\(seconds)")!
        extensionContext!.open(url, completionHandler: nil)
    }

    
}
