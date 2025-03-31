//
//  TodoListPresenterProtocol.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 27.03.2025.
//

import CoreData

protocol TodoListPresenterProtocol: AnyObject {
    var view: TodoListViewProtocol? { get set }
    
    func fetchTodos()
    
    func getNSFetchedResultsController() -> NSFetchedResultsController<TodoEntity>?
    
    func addTodo(todoId: Int)
    func goToTodo(todo: TodoItem)
    func deleteTodo(_ todo: TodoItem)
    func getCountTodo() -> Int
    
    func editTodoState(todo: TodoItem)
    
    func updatePredicate(_ predicate: NSPredicate?)
}
