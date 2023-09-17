//
//  Header+Extension.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import Foundation

public enum Header<H> {
    case contentType(H)
    case token(H)
    case other(key: String, value: H)
    
    mutating func updateValue(for key: String, newValue: H) {
        switch self {
        case .contentType, .token:
            // If the case is contentType or token, no need to update
            break
        case let .other(existingKey, _):
            if existingKey == key {
                // Update the value for the matching key
                self = .other(key: existingKey, value: newValue)
            }
        }
    }
}

// MARK: - Header helper methods

extension Header {
    // Returns a mapped header key:value dict
    var mirror: (String, H) {
        switch self {
        case let .contentType(value):
            return ("Content-Type", value)
        case let .token(token):
            return ("Token", token)
        case let .other(key, value):
            return (key, value)
        }
    }
    
}

public func updateHeaderValue(in headers: inout [Header<String>], forKey key: String, withValue newValue: String) {
    for index in headers.indices {
        switch headers[index] {
        case .other(let existingKey, _):
            if existingKey == key {
                headers[index].updateValue(for: key, newValue: newValue)
            }
        default:
            // Skip cases other than `.other`
            continue
        }
    }
}
