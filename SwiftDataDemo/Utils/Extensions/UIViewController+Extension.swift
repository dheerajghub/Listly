//
//  UIViewController+Extension.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 24/09/23.
//

import UIKit

extension UIViewController {
     
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}
