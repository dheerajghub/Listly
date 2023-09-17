//
//  Convertibles.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import Foundation

// MARK: - URL & URLREQUEST CONVERTIBLES

public protocol URLConvertible {
    var asUrl: Result<URL, Error> { get }
}

public protocol URLRequestConvertible: URLConvertible {
    var asUrlRequest: Result<URLRequest, Error> { get }
}

enum URLConvertibleError: Error {
    case urlComponent
}

extension URLComponents: URLConvertible {
    public var asUrl: Result<URL, Error> {
        guard let url else { return .failure(URLConvertibleError.urlComponent) }
        return .success(url)
    }
}

//:

// MARK: - STRING CONVERTIBLE

public protocol CustomStringConvertible {
    var description: String { get }
}

//:
