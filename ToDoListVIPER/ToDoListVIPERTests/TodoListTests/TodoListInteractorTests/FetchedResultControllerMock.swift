//
//  FetchedResultControllerMock.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 29.03.2025.
//

import CoreData
@testable import ToDoListVIPER

class FetchedResultControllerMock: NSFetchedResultsController<TodoEntity> {
    
    var mockedObjects: [TodoEntity] = []
    private let fakeFetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
    
    override var fetchedObjects: [TodoEntity]? {
        return mockedObjects
    }
    
    override var fetchRequest: NSFetchRequest<TodoEntity> {
        return fakeFetchRequest
    }
}
