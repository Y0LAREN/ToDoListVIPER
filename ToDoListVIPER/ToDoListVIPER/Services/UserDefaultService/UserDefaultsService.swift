//
//  UserDefaultsService.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//


import Foundation

final class UserDefaultsService: UserDefaultsServiceProtocol {
    
    static let shared = UserDefaultsService()
    
    private let isNotFirstTime = "isFirstTime"
    
    func changeNotFirstTime(_ firstTimeValue: Bool) {
        UserDefaults.standard.set(firstTimeValue, forKey: isNotFirstTime)
    }
    
    func getIsNotFirstTime() -> Bool{
        return UserDefaults.standard.bool(forKey: isNotFirstTime)
    }
}
