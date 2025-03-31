//
//  TodoInteractor.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 28.03.2025.
//

import UIKit
import CoreData


final class TodoInteractor: TodoInteractorProtocol {
    weak var presenter: TodoPresenter?
    
    func saveTodo(todo: TodoItem){
        CoreDataService.shared.saveTodo(todo: todo)
    }
    
    func editTodo(todo: TodoItem) {
        CoreDataService.shared.editTodo(todo: todo)
    }
    
    func saveContext(){
        CoreDataService.shared.saveContext()
    }
}
