//
//  AppConstants.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 23/09/23.
//

import UIKit

struct windowConstant {
    
    private static let window = UIApplication.shared.windows.first
    
    static var getTopPadding: CGFloat {
        return window?.safeAreaInsets.top ?? 0
    }
    
    static var getBottomPadding: CGFloat {
        return window?.safeAreaInsets.bottom ?? 0
    }
    
}

struct Colors {
    
    static let appRed = UIColor.colorWithHex(color: "#fe4848")
    static let appBlue = UIColor.colorWithHex(color: "#5264FF")
    
}
