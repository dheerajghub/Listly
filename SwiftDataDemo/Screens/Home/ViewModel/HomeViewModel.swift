//
//  HomeViewModel.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 17/09/23.
//

import Foundation
import SwiftData

class HomeViewModel {
    
    var dataPersistenceService: DataPersistenceService?
    var tasks: [HomeModel] = []
    
    init(){
        createDataPersistenceServiceContainer()
    }
    
    func createDataPersistenceServiceContainer() {
        
        let dataPersistenceService = DataPersistenceService.getInstance()
        dataPersistenceService.createContainer(persistentModels: [HomeModel.self])
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
            
            let discriptor = FetchDescriptor<HomeModel>(sortBy: [SortDescriptor<HomeModel>(\.timestamp)])
            let result = try await dataPersistenceService.fetchData(descriptor: discriptor)
            
            switch result {
            case let .success(taskData):
                guard let taskData else { return .failure(.unknown) }
                self.tasks = taskData
                return .success(true)
            case let .failure(error):
                return .failure(error)
            }
            
        } catch {
            throw DataPersistenceServiceError.unknown
        }
        
    }
    
    func updateTasks(taskId: String) {
        
    }
    
    func deleteTasks(taskId: String) {
        
    }
    
}
