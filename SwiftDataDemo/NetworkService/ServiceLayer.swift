//
//  ServiceLayer.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 16/09/23.
//

import Foundation

enum ServiceLayerError: Error {
    case unknown
    case invalidResponse
    case httpError(_ errorCode: Int)
    case decodingError
}

class ServiceLayer {
    
    static let shared = ServiceLayer()
    private var session: URLSession
    
    init(){
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        self.session = URLSession(configuration: configuration)
    }
    
    func request<T: Codable>(router: HTTPRouter, response: T.Type) async throws -> Result<T?, ServiceLayerError> {
        
        do {
            
            let urlRequest = try router.asURLRequest.get()
            let (serverData, serverUrlResponse) = try await session.data(for: urlRequest)
            
            guard let httpResponse = serverUrlResponse as? HTTPURLResponse else {
                throw ServiceLayerError.invalidResponse
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw ServiceLayerError.httpError(httpResponse.statusCode)
            }
            
            guard let result = try? JSONDecoder().decode(response.self, from: serverData) else {
                throw ServiceLayerError.decodingError
            }
            
            return .success(result)
            
        } catch {
            throw ServiceLayerError.unknown
        }
        
    }
    
}
