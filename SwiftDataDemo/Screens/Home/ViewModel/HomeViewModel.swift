//
//  HomeViewModel.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import UIKit
import SwiftData

class HomeViewModel {
    
    private var dataPersistenceService: DataPersistenceService?
    var tasks: [HomeModel] = []
    
    var isEditing: Bool = false
    var editableTaskIndex: Int?
    
    init(){
        createDataPersistenceServiceContainer()
    }
    
    func createDataPersistenceServiceContainer() {
        
        let dataPersistenceService = DataPersistenceService.getInstance()
        dataPersistenceService.createContainer(persistentModel: HomeModel.self)
        self.dataPersistenceService = dataPersistenceService
        
    }
    
    func saveTask(modelData: HomeModel?){
        
        guard let dataPersistenceService,
              let modelData
        else { return }
        
        dataPersistenceService.saveData(dataModel: modelData)
        
    }
    
    func getTasks() async throws -> Result<Bool?, DataPersistenceServiceError> {
        
        guard let dataPersistenceService
        else { return .failure(.unknown) }
        
        do {
            
            if #available(iOS 17, *) {
                let fetchDiscriptor = FetchDescriptor<HomeModel>(
                    sortBy: [SortDescriptor<HomeModel>(\.orderNum, order: .forward)]
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
    
    func updateTask(task: HomeModel, taskStatus: Int = 0) {
        let taskToBeUpdated = task
        taskToBeUpdated.taskStatus = taskStatus
    }
    
    func deleteTask(task: HomeModel) {
        guard let dataPersistenceService,
              let context = dataPersistenceService.context
        else { return }
        
        context.delete(task)
    }
    
}
