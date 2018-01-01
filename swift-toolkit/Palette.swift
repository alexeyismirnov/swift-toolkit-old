//
//  Palette.swift
//  prayerbook
//
//  Created by Alexey Smirnov on 4/19/17.
//  Copyright © 2017 Alexey Smirnov. All rights reserved.
//

import UIKit
import Chameleon

public let themeChangedNotification  = "THEME_CHANGED"

public class Palette: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PopupContentViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let colors : [UIColor] = [.flatRed(), .flatOrange(), .flatYellow(), .flatSand(), .flatNavyBlue(), .flatBlack(),
                              .flatMagenta(), .flatTeal(), .flatSkyBlue(), .flatGreen(), .flatMint(), .flatWhite(),
                              .flatGray(), .flatForestGreen(), .flatPurple(), .flatBrown(), .flatPlum(), .flatWatermelon(),
                              .flatLime(), .flatPink(), .flatMaroon(), .flatCoffee(), .flatPowderBlue(), .flatBlue(), .flatSandColorDark()]
    
    var edgeInsets: CGFloat!
    var interitemSpacing: CGFloat!
    let numberOfItemsPerRow = 5
    let cellId = "ColorCell"

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            edgeInsets = 10
            interitemSpacing = 5
            
        } else {
            edgeInsets = 20
            interitemSpacing = 10
        }

        collectionView.backgroundColor = .lightGray
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(edgeInsets, edgeInsets, edgeInsets, edgeInsets)
        layout.minimumInteritemSpacing = interitemSpacing
        layout.minimumLineSpacing = interitemSpacing

        let recognizer = UITapGestureRecognizer(target: self, action:#selector(chooseColor(_:)))
        recognizer.numberOfTapsRequired = 1
        collectionView.addGestureRecognizer(recognizer)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        return CGSize(width: size, height: size)
    }
    
    @objc func chooseColor(_ recognizer: UITapGestureRecognizer) {
        let loc = recognizer.location(in: collectionView)
        
        if let path = collectionView.indexPathForItem(at: loc),
            let color = collectionView.cellForItem(at: path)?.backgroundColor {
                Theme.set(.Chameleon(color: color))
            
                let userInfo:[String: UIColor] = ["color": color]
                NotificationCenter.default.post(name: Notification.Name(rawValue: themeChangedNotification), object: nil, userInfo: userInfo)
        }
    }
    
    public func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        if (UIDevice.current.userInterfaceIdiom == .phone) {
            return CGSize(width: 300, height: 300)
            
        } else {
            return CGSize(width: 500, height: 500)
        }
    }
}

