//
//  GithubRequests.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import Foundation

class GithubRequests {
    
    private let serviceLayer = ServiceLayer()
    static let shared = GithubRequests()
    private let githubConfigurations = GithubConfigurations()
    
    func getGithubUser(userName: String) async throws -> Result<GithubUserModel?, ServiceLayerError>  {
        let router = GithubRouter(.getUser(userName: userName), githubConfigurations)
        do {
            return try await serviceLayer.request(router: router, response: GithubUserModel.self)
        } catch let error {
            throw error
        }
    }
    
}
