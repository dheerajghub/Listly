//
//  UIButton+Extension.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import UIKit
typealias ActionBlock = () -> Void

private var eventKey = 0

extension UIButton {
    func handleControlEvent(_ event: UIControl.Event, withBlock action: @escaping () -> Void) {
        objc_setAssociatedObject(self, &eventKey, action, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        addTarget(self, action: #selector(UIButton.callActionBlock(_:)), for: event)
    }
    
    @objc func callActionBlock(_ sender: Any?) {
        let block = objc_getAssociatedObject(self, &eventKey) as? ActionBlock
        if block != nil {
            block?()
        }
    }
    
    func tapFeedback() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
            animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
    
}
