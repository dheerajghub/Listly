//
//  HomeModel.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import Foundation
import SwiftData

enum TaskStatus: Int {
    case todo = 0
    case doing
    case done
}

@Model
class HomeModel {
    
    @Attribute(.unique) var id: String
    var taskName: String?
    var timestamp: Date?
    var taskStatus: Int?
    
    init(id: String = UUID().uuidString,
         taskName: String? = nil,
         timestamp: Date? = nil,
         taskStatus: Int? = nil
    ) {
        self.id = id
        self.taskName = taskName
        self.timestamp = timestamp
        self.taskStatus = taskStatus
    }
}
