//
//  TodoResponse.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//


struct TodoResponse: Decodable {
    let todos: [TodoItem]
    let total: Int
    let skip: Int
    let limit: Int
}
