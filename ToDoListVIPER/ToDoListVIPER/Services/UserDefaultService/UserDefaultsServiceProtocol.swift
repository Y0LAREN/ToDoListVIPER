//
//  UserDefaultsServiceProtocol.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 30.03.2025.
//

protocol UserDefaultsServiceProtocol {
    func changeNotFirstTime(_ firstTimeValue: Bool)
    func getIsNotFirstTime() -> Bool
}
