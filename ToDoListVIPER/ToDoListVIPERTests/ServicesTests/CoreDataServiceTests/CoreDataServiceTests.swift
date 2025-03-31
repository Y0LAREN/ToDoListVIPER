//
//  CoreDataServiceTests.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 29.03.2025.
//

@testable import ToDoListVIPER

import XCTest
import CoreData

final class CoreDataServiceTests: XCTestCase {
    
    var coreDataService: CoreDataServiceProtocol!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        let container = NSPersistentContainer(name: "ToDoListVIPER")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }
        
        context = container.viewContext
        coreDataService = CoreDataServiceMock(context: context)
    }
    
    override func tearDown() {
        coreDataService = nil
        context = nil
    }
    
    func testSaveTodo() throws {
        //Given
        let todo = TodoItem(id: 1, todo: "Test task", completed: false, userId: 1, title: "Test", date: nil)
        coreDataService.saveTodo(todo: todo)
        
        //When
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        let result = try context.fetch(request)
        
        //Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.todo, "Test task")
    }
    
    func testEditTodo() throws {
        //Given
        let date = Date()
        let todo = TodoItem(id: 2, todo: "Old", completed: false, userId: 1, title: "Old Title", date: date)
        coreDataService.saveTodo(todo: todo)
        
        //When
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        let saveTodo = try context.fetch(fetchRequest).first!
        let saveId = Int(saveTodo.id)
        
        let updateTodo = TodoItem(id: saveId, todo: "New", completed: true, userId: 1, title: "New Title", date: date)
        coreDataService.editTodo(todo: updateTodo)
        
        //Then
        let updated = try context.fetch(fetchRequest).first!
        XCTAssertEqual(updated.todo, "New")
        XCTAssertTrue(updated.completed)
    }
    
    func testDeleteTodo() throws {
        //Given
        let todo = TodoItem(id: 3, todo: "To Delete", completed: false, userId: 1, title: "Delete Todo", date: nil)
        coreDataService.saveTodo(todo: todo)
        
        //When
        coreDataService.deleteTodo(todo)
        
        //Then
        let request: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", 3)
        let result = try context.fetch(request)
        
        XCTAssertTrue(result.isEmpty)
    }
}
