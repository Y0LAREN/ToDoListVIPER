//
//  NetworkServiceTests.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 29.03.2025.
//


import XCTest
@testable import ToDoListVIPER
import CoreData

final class UserDefaultsServiceTests: XCTestCase {
    
    var userDefaultsService: UserDefaultsServiceProtocol!
    
    override func setUp() {
        super.setUp()
        userDefaultsService = UserDefaultsServiceMock()
    }
    
    override func tearDown() {
        userDefaultsService = nil
    }
    
    func testChangeNotFirstTime() {
        //Given
        UserDefaults.standard.set(false, forKey: "isFirstTime")
        let oldValue = userDefaultsService.getIsNotFirstTime()
        
        //When
        userDefaultsService.changeNotFirstTime(true)
        let newValue = userDefaultsService.getIsNotFirstTime()
        
        //Then
        XCTAssertNotEqual(oldValue, newValue)
        XCTAssertTrue(newValue)
        
    }
    
    func testGetIsNotFirstTime() {
        //Given
        UserDefaults.standard.set(true, forKey: "isFirstTime")
        
        //When
        let value = userDefaultsService.getIsNotFirstTime()
        
        //Then
        XCTAssertTrue(value)
    }
}
