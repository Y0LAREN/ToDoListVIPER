//
//  TodoListInteractorTests.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 29.03.2025.
//

import XCTest
@testable import ToDoListVIPER
import CoreData

final class TodoListInteractorTests: XCTestCase {
    
    var coreDataService: CoreDataService!
    var todoListInteractor: TodoListInteractor!
    
    override func setUp() {
        super.setUp()
        coreDataService = CoreDataService.shared
        todoListInteractor = TodoListInteractor()
    }
    
    override func tearDown() {
        coreDataService = nil
        todoListInteractor = nil
        super.tearDown()
    }
    
    func testGetCountTodo_ReturnsCorrectCount () {
        //Given
        let fetchedResultControllerMock = FetchedResultControllerMock()
        fetchedResultControllerMock.mockedObjects = [TodoEntity(), TodoEntity()]
        todoListInteractor.fetchedResultController = fetchedResultControllerMock
        
        //Then
        let count = todoListInteractor.getCountTodo()
        
        //When
        XCTAssertEqual(count, 2)
    }
    
    func testUpdatePredicate_ChangesPredicate () {
        //Given
        let fetchedResultControllerMock = FetchedResultControllerMock()
        todoListInteractor.fetchedResultController = fetchedResultControllerMock
        
        let predicate = NSPredicate(format: "completed == true")
        
        //Then
        todoListInteractor.updatePredicate(predicate)
        
        //When
        XCTAssertEqual(fetchedResultControllerMock.fetchRequest.predicate, predicate)
    }
    
    func testFetchTodos_WhenFirstTime_CallsFetchJSONTodos() {
        //Given
        class TodoListInteractorMock: TodoListInteractor {
            var fetchJSONCalled = false
            
            override func fetchJSONTodos() {
                fetchJSONCalled = true
            }
        }
        
        let mockInteractor = TodoListInteractorMock()
        UserDefaultsService.shared.changeNotFirstTime(false)
        
        //When
        mockInteractor.fetchTodos()
        
        //Then
        XCTAssertTrue(mockInteractor.fetchJSONCalled)
    }
}
