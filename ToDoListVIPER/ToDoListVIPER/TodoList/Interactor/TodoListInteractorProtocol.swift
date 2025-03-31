//
//  TodoListInteractorProtocol.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 27.03.2025.
//

import CoreData

protocol TodoListInteractorProtocol: AnyObject {
    var fetchedResultController: NSFetchedResultsController<TodoEntity>? { get set }
    
    func fetchTodos()
    
    func saveTodo(_ todo: TodoItem)
    func editTodo(_ todo: TodoItem)
    func deleteTodo(_ todo: TodoItem)
    func getCountTodo() -> Int
    
    func saveContext()
    
    func updatePredicate(_ predicate: NSPredicate?)
}
