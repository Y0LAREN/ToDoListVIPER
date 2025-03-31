//
//  TodoListRouterProtocol.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 27.03.2025.
//

import UIKit
protocol TodoListRouterProtocol {
    func goToTodo(todo: TodoItem?, todoId: Int, mode: TodoGoMode)
}
