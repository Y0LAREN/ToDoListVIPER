//
//  CoreDataServiceProtocol.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//


import Foundation

protocol CoreDataServiceProtocol {
    func saveTodo(todo: TodoItem)
    func editTodo(todo: TodoItem)
    func deleteTodo(_ todo: TodoItem)
}
