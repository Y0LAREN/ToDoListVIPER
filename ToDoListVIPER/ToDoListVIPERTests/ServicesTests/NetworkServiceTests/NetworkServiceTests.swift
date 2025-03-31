//
//  CoreDataServiceTests.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 29.03.2025.
//


import XCTest
@testable import ToDoListVIPER

final class NetworkServiceTests: XCTestCase {
    
    override class func setUp() {
        URLProtocol.registerClass(URLProtocolMock.self)
    }
    
    override class func tearDown() {
        URLProtocol.unregisterClass(URLProtocolMock.self)
    }
    
    func testFetchTodosSuccess() {
        //Given
        let expectation = self.expectation(description: "Todos fetched")
        
        let mockData = """
                {
                "todos": [
                { "id": 1, "todo": "Test Task", "completed": false, "userId": 1 }
                  ],"total":254,"skip":0,"limit":30
                }
                """.data(using: .utf8)!
        
        URLProtocolMock.requestHandler = { request in
            return (HTTPURLResponse(), mockData)
        }
        
        //When
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        let service = NetworkService(session: session)
        
        //Then
        service.fetchTodos{ result in
            switch result {
                case .success(let todos):
                    XCTAssertEqual(todos.count, 1)
                    XCTAssertEqual(todos.first?.todo, "Test Task")
                case .failure(let error):
                    XCTFail("Unexpected failure: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testFetchTodosFailure() {
        //Given
        let expectation = self.expectation(description: "Todos fetch fails")
        URLProtocolMock.requestHandler = { request in
            throw NSError(domain: "Test", code: 123, userInfo: nil)
        }
        
        //When
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)
        
        let service = NetworkService(session: session)
        
        //Then
        service.fetchTodos { result in
            switch result {
                case .success:
                    XCTFail("Expected failure, got success")
                case .failure(let error):
                    XCTAssertEqual((error as NSError).code, 123)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
}
