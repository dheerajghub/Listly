//
//  Helper.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 24/09/23.
//

import UIKit

class Helper {
    
    static func showAlert(message: String, controller: UIViewController, alertType: CustomAlertType = .default, _ completion: @escaping ((Bool) -> Void)){
        
        let vc = CustomAlertViewController(alertType: alertType, message: message)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.actionCallback = { result in
            completion(result)
        }
        
        controller.present(vc, animated: true)
        
    }
    
}
