//
//  TodoItem.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//

import Foundation

// MARK: - Entity
struct TodoItem: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
    
    let title: String?
    let date: Date?
}
