//
//  ViewControllerAnimated.swift
//  swift-toolkit
//
//  Created by Alexey Smirnov on 10/12/17.
//  Copyright © 2017 Alexey Smirnov. All rights reserved.
//

import UIKit

open class UIViewControllerAnimated : UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    var animation = UIViewControllerAnimator()
    var animationInteractive = UIViewControllerAnimatorInteractive()
    
    override open func viewDidLoad() {
        navigationController?.delegate = self
        animationInteractive.completionSpeed = 0.999
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        pan.delegate = self
        view.addGestureRecognizer(pan)
    }
    
    public func viewControllerCurrent() -> UIViewController {
        fatalError("This method must be overridden")
    }
    
    public func viewControllerForward() -> UIViewController {
        fatalError("This method must be overridden")
    }
    
    public func viewControllerBackward() -> UIViewController {
        fatalError("This method must be overridden")
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return (animation.direction != .none) ? animation : nil
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return (animation.direction != .none) ? animationInteractive : nil
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let recognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = recognizer.velocity(in: view)
            return abs(velocity.x) > abs(velocity.y)
        }
        
        return true
    }
    
    @objc func didPan(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let velocity = recognizer.velocity(in: view)
            animationInteractive.velocity = velocity
            
            if velocity.x < 0 {
                animation.direction = .positive
                navigationController?.pushViewController(viewControllerForward(), animated: true)
                
            } else {
                animation.direction = .negative
                navigationController?.pushViewController(viewControllerBackward(), animated: true)
            }
            
        case .changed:
            animationInteractive.handlePan(recognizer: recognizer)
            
        case .ended:
            animationInteractive.handlePan(recognizer: recognizer)
            
            if animationInteractive.cancelled {
                let vc = viewControllerCurrent()
                navigationController?.setViewControllers([vc], animated: false)
                
            } else {
                let top = navigationController?.topViewController!
                navigationController?.setViewControllers([top!], animated: false)
            }
            
        default:
            break
        }
    }
    
}

public protocol ResizableTableViewCells {
    weak var tableView: UITableView! { get set }
}

public extension ResizableTableViewCells where Self: UIViewController {
    public func getSimpleCell() -> UITableViewCell {
        let newCell  = tableView.dequeueReusableCell(withIdentifier: "cell")!
        newCell.accessoryType = .none
        return newCell
    }
    
    public func getCell<T: ConfigurableCell>() -> T {
        if let newCell  = tableView.dequeueReusableCell(withIdentifier: T.cellId) as? T {
            newCell.accessoryType = .none
            newCell.backgroundColor = .clear
            return newCell
            
        } else {
            return T(style: UITableViewCellStyle.default, reuseIdentifier: T.cellId)
        }
    }
    
    public func calculateHeightForCell(_ cell: UITableViewCell) -> CGFloat {
        cell.bounds = CGRect(x: 0, y: 0, width: tableView.frame.width, height: cell.bounds.height)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let size = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        return size.height+1.0
    }
}

