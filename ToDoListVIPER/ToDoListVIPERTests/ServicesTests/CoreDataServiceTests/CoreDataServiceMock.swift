//
//  CoreDataServiceFake.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 30.03.2025.
//

@testable import ToDoListVIPER

import CoreData

final class CoreDataServiceMock: CoreDataServiceProtocol {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveTodo(todo: TodoItem) {
        let newTodo = TodoEntity(context: context)
        newTodo.id = Int64.random(in: 1...100000)
        newTodo.todo = todo.todo
        newTodo.completed = todo.completed
        newTodo.userId = Int64(todo.userId)
        newTodo.title = todo.title
        newTodo.date = Date()
        
        try? context.save()
    }
    
    func editTodo(todo: TodoItem) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
        
        if let todoToEdit = try? context.fetch(fetchRequest).first {
            todoToEdit.title = todo.title
            todoToEdit.todo = todo.todo
            todoToEdit.completed = todo.completed
            
            try? context.save()
        }
    }
    
    func deleteTodo(_ todo: TodoItem) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)

        if let todoToDelete = try? context.fetch(fetchRequest).first {
            context.delete(todoToDelete)
            try? context.save()
        }
    }
}
