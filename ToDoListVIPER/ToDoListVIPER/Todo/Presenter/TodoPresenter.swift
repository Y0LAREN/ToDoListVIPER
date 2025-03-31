//
//  TodoPresenter.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 28.03.2025.
//

import UIKit

final class TodoPresenter: TodoPresenterProtocol {
    weak var view: TodoViewProtocol?
    var interactor: TodoInteractorProtocol?
    var router: TodoRouterProtocol?
    var isEditing: Bool = false
    
    func viewWillDisappear(todo: TodoItem) {
        isEditing ? interactor?.editTodo(todo: todo) : interactor?.saveTodo(todo: todo)
    }
    
    func checkTodoIsNil(checkIsEditing: Bool) {
        if checkIsEditing {
            isEditing = true
        }
        else {
            isEditing = false
        }
    }
}
