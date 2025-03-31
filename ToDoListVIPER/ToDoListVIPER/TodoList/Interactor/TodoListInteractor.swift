//
//  TodoListInteractor.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 27.03.2025.
//

import UIKit
import CoreData


class TodoListInteractor: TodoListInteractorProtocol {
    
    weak var presenter: TodoListPresenter?
    var fetchedResultController: NSFetchedResultsController<TodoEntity>?
    
    let fetchRequest = TodoEntity.fetchRequest()
    
    init(presenter: TodoListPresenter? = nil, fetchedResultController: NSFetchedResultsController<TodoEntity>? = nil) {
        self.presenter = presenter
        self.fetchedResultController = fetchedResultController
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        self.fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataService.shared.context,
            sectionNameKeyPath: nil,
            cacheName: nil)
        self.fetchedResultController?.delegate = presenter?.view
        
        do {
            try self.fetchedResultController?.performFetch()
        } catch {
            print("Ошибка при выполнении fetch: \(error.localizedDescription)")
        }
    }
    
    func fetchTodos() {
        if !UserDefaultsService.shared.getIsNotFirstTime(){
            fetchJSONTodos()
        }
    }
    
    func saveTodo(_ todo: TodoItem) {
        CoreDataService.shared.saveTodo(todo: todo)
    }
    
    func editTodo(_ todo: TodoItem) {
        CoreDataService.shared.editTodo(todo: todo)
    }
    
    func deleteTodo(_ todo: TodoItem) {
        CoreDataService.shared.deleteTodo(todo)
    }
    
    func saveContext(){
        CoreDataService.shared.saveContext()
    }
    
    func updatePredicate(_ predicate: NSPredicate?) {
        fetchedResultController?.fetchRequest.predicate = predicate
        do {
            try fetchedResultController?.performFetch()
        } catch {
            print("Ошибка при обновлении predicate: \(error)")
        }
    }
    
    func getCountTodo() -> Int {
        fetchedResultController?.fetchedObjects?.count ?? 0
    }
    
    func fetchJSONTodos() {
        DispatchQueue.global(qos: .background).async {
            NetworkService.shared.fetchTodos { result in
                switch result {
                    case .success(let todos):
                        print("Загружено \(todos.count) задач")
                        if !UserDefaultsService.shared.getIsNotFirstTime() {
                            for todo in todos {
                                self.saveTodo(todo)
                                print("\(todo.id): \(todo.todo) - \(todo.completed ? "YES" : "NO")")
                            }
                            print("save all JSON Success")
                            UserDefaultsService.shared.changeNotFirstTime(true)
                        }
                        
                    case .failure(let error):
                        print("Ошибка загрузки: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
