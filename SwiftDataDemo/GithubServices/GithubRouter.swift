//
//  GithubRouter.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 16/09/23.
//

import Foundation

enum EndPoint: CustomStringConvertible {
    case getUser(userName: String)
    case getFollowers(userName: String)
    case getRepoList(userName: String)
    case getRepoDetails(userName: String, repoName: String)
    case getContributors(userName: String, repoName: String)
    
    var description: String {
        switch self {
        case .getUser:
            "Get github user using username"
        case .getFollowers:
            "Get github followers for given username"
        case .getRepoList:
            "Get github repository list for given username"
        case .getRepoDetails:
            "Get github repository detail for given user's repository"
        case .getContributors:
            "Get github repository contributors for given user's repository"
        }
    }
    
}

struct GithubRouter: HTTPRouter {
    
    var serviceConfigurations: ServiceConfigurations
    var endPoint: EndPoint
    
    // MARK: - Initializer
    
    init(_ endPoint: EndPoint, _ serviceConfigurations: ServiceConfigurations) {
        self.endPoint = endPoint
        self.serviceConfigurations = serviceConfigurations
    }
    
    //:
    
    var methods: HTTPMethods {
        switch endPoint {
        case .getContributors, .getUser, .getFollowers, .getRepoList, .getRepoDetails:
            return .get
        }
    }
    
    var path: Result<String, Error> {
        
        let path: String
        
        switch endPoint {
        case let .getUser(userName):
            path = "/users/\(userName)"
        case let .getFollowers(userName):
            path = "/users/\(userName)/followers"
        case let .getRepoList(userName):
            path = "/users/\(userName)/repos"
        case let .getRepoDetails(userName, repoName):
            path = "/repos/\(userName)/\(repoName)"
        case let .getContributors(userName, repoName):
            path = "/repos/\(userName)/\(repoName)/contributors"
        }

        return .success(path)
    }
    
    var queryItems: Result<[URLQueryItem], Error> {
        let query: [URLQueryItem] = []
        return .success(query)
    }
    
}
