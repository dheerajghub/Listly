//
//  GithubConfigurations.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import Foundation

public struct GithubConfigurations: ServiceConfigurations {
    
    public var host: String
    public var headers: [Header<String>]
    
    init(host: String = "api.github.com",
         headers: [Header<String>] = []
    ) {
        self.host = host
        self.headers = headers
    }
    
}
