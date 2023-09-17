//
//  GithubUserModel.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import Foundation
import SwiftData

@Model
class GithubUserModel: Codable {
    @Attribute(.unique) var id: Int?
    var login: String?
    var nodeID: String?
    var avatarURL: String?
    var gravatarID: String?

    enum CodingKeys: String, CodingKey {
        case login, id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
    }
    
    init(id: Int? = nil, login: String?, nodeID: String?, avatarURL: String?, gravatarID: String?) {
        self.id = id
        self.login = login
        self.nodeID = nodeID
        self.avatarURL = avatarURL
        self.gravatarID = gravatarID
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.login = try container.decode(String.self, forKey: .login)
        self.nodeID = try container.decode(String.self, forKey: .nodeID)
        self.gravatarID = try container.decode(String.self, forKey: .gravatarID)
        self.avatarURL = try container.decode(String.self, forKey: .avatarURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(login, forKey: .login)
        try container.encode(nodeID, forKey: .nodeID)
        try container.encode(gravatarID, forKey: .gravatarID)
        try container.encode(avatarURL, forKey: .avatarURL)
        try container.encode(gravatarID, forKey: .gravatarID)
    }
    
}
