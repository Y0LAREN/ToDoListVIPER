//
//  UserDefaultsServiceMock.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 30.03.2025.
//

@testable import ToDoListVIPER
import Foundation

final class UserDefaultsServiceMock: UserDefaultsServiceProtocol {
    
    private let isNotFirstTime = "isFirstTime"
    
    func changeNotFirstTime(_ firstTimeValue: Bool) {
        UserDefaults.standard.set(firstTimeValue, forKey: isNotFirstTime)
    }
    
    func getIsNotFirstTime() -> Bool {
        return UserDefaults.standard.bool(forKey: isNotFirstTime)
    }
}
