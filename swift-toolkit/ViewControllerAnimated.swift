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
    
    var panGesture :UIPanGestureRecognizer!
    
    override open func viewDidLoad() {
        navigationController?.delegate = self
        animationInteractive.completionSpeed = 0.999
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }
    
    open func viewControllerCurrent() -> UIViewController {
        fatalError("This method must be overridden")
    }
    
    open func viewControllerForward() -> UIViewController {
        fatalError("This method must be overridden")
    }
    
    open func viewControllerBackward() -> UIViewController {
        fatalError("This method must be overridden")
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return (animation.direction != .none) ? animation : nil
    }
    
    public func navigationController(_ navigationController: UINavigationController,
                                     interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return (animation.direction != .none) ? animationInteractive : nil
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
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
    func getSimpleCell() -> UITableViewCell {
        let newCell  = tableView.dequeueReusableCell(withIdentifier: "cell")!
        newCell.accessoryType = .none
        return newCell
    }
    
    func getCell<T: ConfigurableCell>() -> T {
        if let newCell  = tableView.dequeueReusableCell(withIdentifier: T.cellId) as? T {
            newCell.accessoryType = .none
            newCell.backgroundColor = .clear
            return newCell
            
        } else {
            return T(style: UITableViewCell.CellStyle.default, reuseIdentifier: T.cellId)
        }
    }
    
    func calculateHeightForCell(_ cell: UITableViewCell) -> CGFloat {
        cell.bounds = CGRect(x: 0, y: 0, width: tableView.frame.width-1, height: cell.bounds.height)
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let size = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size.height+1.0
    }
}

