//
//  TodoListPresenterProtocol.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 28.03.2025.
//

protocol TodoPresenterProtocol: AnyObject {
    func viewWillDisappear(todo: TodoItem)
    func checkTodoIsNil(checkIsEditing: Bool)
}
