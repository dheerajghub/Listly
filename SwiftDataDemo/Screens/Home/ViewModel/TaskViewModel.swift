//
//  TaskViewModel.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import UIKit
import SwiftData

class TaskViewModel {
    
    private var dataPersistenceService: DataPersistenceService?
    var tasks: [TaskModel] = []
    
    var isEditing: Bool = false
    var editableTaskIndex: Int?
    
    init(){
        createDataPersistenceServiceContainer()
    }
    
    func createDataPersistenceServiceContainer() {
        
        let dataPersistenceService = DataPersistenceService.getInstance()
        dataPersistenceService.createContainer(persistentModel: TaskModel.self)
        self.dataPersistenceService = dataPersistenceService
        
    }
    
    func saveTask(modelData: TaskModel?){
        
        guard let dataPersistenceService,
              let modelData
        else { return }
        
        dataPersistenceService.saveData(dataModel: modelData)
        
    }
    
    func getTasks(isArchived: Bool = false) async throws -> Result<Bool?, DataPersistenceServiceError> {
        
        guard let dataPersistenceService
        else { return .failure(.unknown) }
        
        do {
            
            if #available(iOS 17, *) {
                let fetchDiscriptor = FetchDescriptor<TaskModel>(
                    predicate: #Predicate<TaskModel> { $0.isArchived == isArchived },
                    sortBy: [SortDescriptor<TaskModel>(\.orderNum, order: .forward)]
                )
                
                let result = try await dataPersistenceService.fetchData(descriptor: fetchDiscriptor)
                
                switch result {
                case let .success(taskData):
                    guard let taskData else { return .failure(.unknown) }
                    self.tasks = taskData
                    return .success(true)
                case let .failure(error):
                    return .failure(error)
                }
                
            } else {
                // Fallback on earlier versions
                return .success(false)
            }
            
        } catch {
            throw DataPersistenceServiceError.unknown
        }
        
    }
    
    func updateTask(
        task: TaskModel,
        taskStatus: Int? = nil,
        isArchived: Bool? = nil,
        isSelectedForEditing: Bool? = nil
    ) {
        let taskToBeUpdated = task
        
        /// update only if not nil
        
        if let taskStatus {
            taskToBeUpdated.taskStatus = taskStatus
        }
       
        if let isArchived {
            taskToBeUpdated.isArchived = isArchived
        }
        
        if let isSelectedForEditing {
            taskToBeUpdated.isSelectedForEditing = isSelectedForEditing
        }
        
    }
    
    // for bulk updates
    func updateTasks(
        tasks: [TaskModel],
        isSelectedForEditing: Bool? = nil,
        isArchived: Bool? = nil
    ) {
        
        for task in tasks {
            
            if let isSelectedForEditing {
                task.isSelectedForEditing = isSelectedForEditing
            }
            
            if let isArchived {
                task.isArchived = isArchived
            }
            
        }
        
    }
    
    func deleteTask(task: TaskModel) {
        guard let dataPersistenceService,
              let context = dataPersistenceService.context
        else { return }
        
        context.delete(task)
    }
    
}
