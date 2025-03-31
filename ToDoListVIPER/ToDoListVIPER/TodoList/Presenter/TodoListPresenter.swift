//
//  TodoListPresenter.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 27.03.2025.
//

import UIKit
import CoreData

final class TodoListPresenter: TodoListPresenterProtocol {
    
    var view: (any TodoListViewProtocol)?
    var interactor: TodoListInteractorProtocol?
    var router: TodoListRouterProtocol?
    
    func fetchTodos() {
        interactor?.fetchTodos()
    }
    
    func addTodo(todoId: Int) {
        router?.goToTodo(todo: nil, todoId: todoId, mode: .addTodo)
    }
    
    func goToTodo(todo: TodoItem) {
        print("todo: \(todo)")
        router?.goToTodo(todo: todo, todoId: todo.id, mode: .editTodo)
    }
    
    func deleteTodo(_ todo: TodoItem) {
        interactor?.deleteTodo(todo)
        interactor?.fetchTodos()
    }
    
    func editTodoState(todo: TodoItem){
        interactor?.editTodo(todo)
        interactor?.saveContext()
    }
    
    func updatePredicate(_ predicate: NSPredicate?){
        interactor?.updatePredicate(predicate)
    }
    
    func getCountTodo() -> Int{
        interactor?.getCountTodo() ?? 0
    }
    
    func getNSFetchedResultsController() -> NSFetchedResultsController<TodoEntity>? {
        return interactor?.fetchedResultController
    }
}
