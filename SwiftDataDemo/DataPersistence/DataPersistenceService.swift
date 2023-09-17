//
//  DataPersistenceService.swift
//  SwiftDataDemo
//
//  Created by Dheeraj Kumar Sharma on 16/09/23.
//

import Foundation
import SwiftData

enum DataPersistenceServiceError: Error {
    case invalid
    case unknown
    case contextNotFound
    case none
}

class DataPersistenceService {
    
    private static var sharedInstance: DataPersistenceService!
    
    private var container: ModelContainer?
    private var context: ModelContext?
    
    public static func getInstance() -> DataPersistenceService {
        if sharedInstance == nil {
            sharedInstance = DataPersistenceService()
        }
        return sharedInstance
    }
    
    func createContainer(persistentModels: [any PersistentModel.Type]){
        do {
            let container = try ModelContainer(for: persistentModels)
            self.container = container
            self.context = ModelContext(container)
        } catch {
            print(error)
        }
    }
    
    func saveData<T: PersistentModel>(dataModel: T?){
        
        guard let context,
              let dataModel
        else { return }
        
        context.insert(dataModel)
        
    }
    
    func fetchData<T>(descriptor: FetchDescriptor<T>) async throws -> Result<[T]?, DataPersistenceServiceError> {
        
        guard let context
        else { return .failure(DataPersistenceServiceError.contextNotFound) }
        
        do{
            let data = try context.fetch(descriptor)
            return .success(data)
        } catch{
            return .failure(DataPersistenceServiceError.invalid)
        }
        
    }
    
    func updateData(){
        
    }
    
    func deleteData(dataModel: any PersistentModel){
        
        guard let context
        else { return }
        
        context.delete(dataModel)
        
    }
    
}
