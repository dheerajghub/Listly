//
//  HTTPRouter.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 16/09/23.
//

import Foundation

public enum HTTPMethods: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
}


public protocol HTTPRouter: URLConvertible {
    
    var serviceConfigurations: ServiceConfigurations { get }
    var methods: HTTPMethods { get }
    var path: Result<String, Error> { get }
    var queryItems: Result<[URLQueryItem], Error> { get }
    var additionalHeaders: [String: String] { get }
    var body: Result<Data?, Error> { get }
    
}

extension HTTPRouter {
    
    public var asUrl: Result<URL, Error> {
        
        return path.flatMap { path -> Result<URLComponents, Error> in
            
            queryItems.map { query -> URLComponents in
                
                var urlComponents = URLComponents()
                urlComponents.scheme = serviceConfigurations.urlScheme
                urlComponents.host = serviceConfigurations.host
                urlComponents.path = path
                urlComponents.queryItems = query
                
                // sanitization
                /// decoding double encoded slashes for `Path`
                urlComponents.percentEncodedPath = urlComponents.percentEncodedPath.replacingOccurrences(of: "%252F", with: "%2F")
                
                /// encoding for `+` and `?` for `Query`
                urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B").replacingOccurrences(of: "?", with: "%3F")
                
                return urlComponents
            }
            
        }.flatMap{ $0.asUrl }
        
    }
    
    public var asURLRequest: Result<URLRequest, Error> {
        
        return asUrl.flatMap { url -> Result<URLRequest, Error> in
            
            body.flatMap { data in
                
                var request = URLRequest(url: url)
                request.httpMethod = methods.rawValue
                request.allHTTPHeaderFields = additionalHeaders
                request.httpBody = data
                
                return .success(request)
                
            }
            
        }
        
    }
    
}

// MARK: - Assigning Default Protocol Values

extension HTTPRouter {
    
    public var methods: HTTPMethods { return .get }
    
    public var body: Result<Data? , Error> { return .success(nil) }
    
    var additionalHeaders: [String: String] {
        return (serviceConfigurations.headers.reduce([:]) { headerDict, header in
            var resultDict: [String: String]? = headerDict
            resultDict?[header.mirror.0] = header.mirror.1
            return resultDict ?? [:]
        })
    }
    
}
