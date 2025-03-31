//
//  TodoListInteractorProtocol.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 28.03.2025.
//

protocol TodoInteractorProtocol: AnyObject {
    func editTodo(todo: TodoItem)
    func saveTodo(todo: TodoItem)
    
    func saveContext()
}
