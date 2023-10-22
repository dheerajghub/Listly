//
//  TaskModel.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import Foundation
import SwiftData

enum TaskStatus: Int {
    case todo = 0
    case done
}

@Model
class TaskModel {
    
    @Attribute(.unique) var id: String
    var taskName: String?
    var timestamp: Date?
    var taskStatus: Int
    var orderNum: Int?
    var isArchived: Bool
    var isSelectedForEditing: Bool
    var dueOn: Date?
    
    init(id: String = UUID().uuidString,
         taskName: String? = nil,
         timestamp: Date? = Date(),
         taskStatus: Int = 0,
         orderNum: Int? = 1,
         isArchived: Bool = false,
         isSelectedForEditing: Bool = false,
         dueOn: Date? = nil
    ) {
        self.id = id
        self.taskName = taskName
        self.timestamp = timestamp
        self.taskStatus = taskStatus
        self.orderNum = orderNum
        self.isArchived = isArchived
        self.isSelectedForEditing = isSelectedForEditing
        self.dueOn = dueOn
    }
}
