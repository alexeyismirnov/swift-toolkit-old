//
//  BookPage.swift
//  ponomar
//
//  Created by Alexey Smirnov on 5/15/19.
//  Copyright © 2019 Alexey Smirnov. All rights reserved.
//

import UIKit

public class FontSizeViewController : UIViewController, PopupContentViewController {
    let prefs = AppGroup.prefs!
    var delegate: BookPage!
    
    var text : String!
    var fontSize: Int!
    var con : [NSLayoutConstraint]!
    
    override public func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(hex: "#FFEBCD")
        
        let label = UILabel()
        label.text = "Размер шрифта"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .black
        
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.thumbTintColor = .gray
        slider.minimumValue = 12
        slider.maximumValue = 30
        slider.setValue(Float(fontSize), animated: false)
        
        slider.addTarget(self, action: #selector(self.sliderVlaue(_:)), for: .valueChanged)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        view.addSubview(label)
        view.addSubview(slider)
        view.addSubview(button)
        
        con = [
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: slider.topAnchor, constant: -20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 100.0),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),

        ]
        
        NSLayoutConstraint.activate(con)
    }
    
    @objc func sliderVlaue(_ sender: UISlider) {
        prefs.set(Int(sender.value), forKey: "fontSize")
        prefs.synchronize()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        UIViewController.popup.dismiss()
    }
    
    public func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 250, height: 170)
    }
}

public class BookPage: UIViewController {
    let prefs = AppGroup.prefs!
    var fontSize : Int
    
    var model : BookModel
    var pos : BookPosition
    
    var bookmark: String
    
    var button_fontsize, button_add_bookmark, button_remove_bookmark : CustomBarButton!
    var button_close, button_next, button_prev : CustomBarButton!
    
    var contentView1, contentView2: UIView!    
    func createContentView(_ pos: BookPosition, _ frame: CGRect? = nil) -> UIView { preconditionFailure("This method must be overridden") }

    func reloadTheme() { preconditionFailure("This method must be overridden") }
    
    public init?(_ pos: BookPosition) {
        guard let model = pos.model else { return nil }
        
        self.model = model
        self.pos = pos
        self.bookmark = model.getBookmark(at: pos)
        
        fontSize = prefs.integer(forKey: "fontSize")
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createNavigationButtons() {
        automaticallyAdjustsScrollViewInsets = false
        
        let toolkit = Bundle(identifier: "com.rlc.swift-toolkit")
        
        button_close = CustomBarButton(image: UIImage(named: "close", in: toolkit, compatibleWith: nil), style: .plain, target: self, action: #selector(close))
        
        button_next = CustomBarButton(image: UIImage(named: "arrow-right", in: toolkit, compatibleWith: nil), style: .plain, target: self, action: #selector(showNext))
        
        button_prev = CustomBarButton(image: UIImage(named: "arrow-left", in: toolkit, compatibleWith: nil), style: .plain, target: self, action: #selector(showPrev))
        
        button_fontsize = CustomBarButton(image: UIImage(named: "fontsize", in: toolkit, compatibleWith: nil)!
            , target: self, btnHandler: #selector(self.showFontSizeDialog))
        
        button_add_bookmark = CustomBarButton(image: UIImage(named: "add_bookmark", in: toolkit, compatibleWith: nil)!
            , target: self, btnHandler: #selector(self.addBookmark))
        
        button_remove_bookmark = CustomBarButton(image: UIImage(named: "remove_bookmark", in: toolkit, compatibleWith: nil)!
            , target: self, btnHandler: #selector(self.removeBookmark))
    }
    
    @objc func showNext() {
        if let nextPos = model.getNextSection(at: pos) {
            let width = view.frame.width

            var frame = fullScreenFrame
            frame.origin.x = width
            
            contentView2 = self.createContentView(nextPos, frame)

            UIView.animate(withDuration: 0.5,
                           animations: {
                                self.contentView1.frame.origin.x -= width
                                self.contentView2.frame.origin.x -= width
                            },
                           completion: { _ in
                            self.contentView1.removeFromSuperview()
                            self.contentView1 = self.contentView2

                            self.pos = nextPos
                            self.bookmark = self.model.getBookmark(at: self.pos)
                            self.updateNavigationButtons()
            })
            
        }
    }
    
    @objc func showPrev() {
        if let prevPos = model.getPrevSection(at: pos) {
            let width = view.frame.width
            
            var frame = fullScreenFrame
            frame.origin.x = -width
            
            contentView2 = self.createContentView(prevPos, frame)
            
            UIView.animate(withDuration: 0.5,
                           animations: {
                            self.contentView1.frame.origin.x += width
                            self.contentView2.frame.origin.x += width
                        },
                           completion: { _ in
                            self.contentView1.removeFromSuperview()
                            self.contentView1 = self.contentView2
                            
                            self.pos = prevPos
                            self.bookmark = self.model.getBookmark(at: self.pos)
                            self.updateNavigationButtons()
            })
            
        }
    }
    
    @objc func addBookmark() {
        var bookmarks = prefs.stringArray(forKey: "bookmarks")!
        bookmarks.append(bookmark)
        prefs.set(bookmarks, forKey: "bookmarks")
        prefs.synchronize()
        
        navigationItem.rightBarButtonItems = [button_fontsize, button_remove_bookmark]
    }
    
    @objc func removeBookmark() {
        var bookmarks = prefs.stringArray(forKey: "bookmarks")!
        bookmarks.removeAll(where: { $0 == bookmark })
        prefs.set(bookmarks, forKey: "bookmarks")
        prefs.synchronize()
        
        navigationItem.rightBarButtonItems = [button_fontsize, button_add_bookmark]
    }
    
    func updateNavigationButtons() {
        if model.hasNavigation {
            let bookmarks = prefs.stringArray(forKey: "bookmarks")!
            
            navigationItem.rightBarButtonItems = bookmarks.contains(bookmark)  ? [button_fontsize, button_remove_bookmark]:
                [button_fontsize, button_add_bookmark]
            
            var nav_buttons = [CustomBarButton]()
            
            if let _ = model.getPrevSection(at: pos) {
                nav_buttons.append(button_prev)
            }
            
            if let _ = model.getNextSection(at: pos) {
                nav_buttons.append(button_next)
            }
            
            nav_buttons.insert(button_close, at: 0)
            navigationItem.leftBarButtonItems = nav_buttons

        } else {
            navigationItem.rightBarButtonItem = button_fontsize
            navigationItem.leftBarButtonItem = button_close
        }
      
    }
    
    @objc func close() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func showFontSizeDialog() {
        let vc = FontSizeViewController()
        vc.fontSize = fontSize
        vc.delegate = self
        
        showPopup(vc, onClose: { _ in  self.reloadTheme() })
    }

}
