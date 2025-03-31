//
//  ToDoListRouter.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 28.03.2025.
//


import UIKit

final class TodoRouter {
    weak var viewController: UIViewController?
    
    static func createModule(todo: TodoItem?, todoId: Int, mode: TodoGoMode) -> UIViewController {
        let presenter = TodoPresenter()
        let interactor = TodoInteractor()
        let router = TodoRouter()
        var view = TodoViewController(todo: todo, mode: mode)
        switch mode {
            case .editTodo:
                view = TodoViewController(todo: todo, mode: mode)
            case .addTodo:
                view = TodoViewController(todo: TodoItem(id: todoId, todo: "", completed: false, userId: Int.random(in: 1...1000), title: nil, date: Date()), mode: mode)
        }
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}

extension TodoRouter: TodoRouterProtocol {
    func popToRootViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
