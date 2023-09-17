//
//  ServiceConfigurations.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import Foundation

public protocol ServiceConfigurations {
    
    var urlScheme: String { get }
    var host: String { get }
    var headers: [Header<String>] { get }
    
}

extension ServiceConfigurations {
    
    public var urlScheme: String { return "https" }
    
}
