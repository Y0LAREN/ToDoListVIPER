//
//  TodoListRouter.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 27.03.2025.
//

import UIKit
import CoreData

final class TodoListRouter{
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = TodoListViewController()
        let presenter = TodoListPresenter()
        let interactor = TodoListInteractor()
        let router = TodoListRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.fetchedResultController?.delegate = view
        
        router.viewController = view
        
        return view
    }
}

extension TodoListRouter: TodoListRouterProtocol {
    func goToTodo(todo: TodoItem?, todoId: Int, mode: TodoGoMode) {
        let todoVC = TodoRouter.createModule(todo: todo, todoId: todoId, mode: mode)
        viewController?.navigationController?.pushViewController(todoVC, animated: true)
    }
}
