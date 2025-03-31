//
//  CoreDataService.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//

import UIKit
import CoreData

final class CoreDataService: CoreDataServiceProtocol {
    
    static let shared = CoreDataService()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}
    
    func saveTodo(todo: TodoItem) {
        let newTodo = TodoEntity(context: context)
        newTodo.id = Int64.random(in: 1...100000)
        newTodo.todo = todo.todo
        newTodo.completed = todo.completed
        newTodo.userId = Int64(todo.userId)
        newTodo.title = todo.title
        newTodo.date = Date()
        
        do {
            try context.save()
        } catch {
            print("Error saving todo: \(error.localizedDescription)")
        }
    }
    
    func editTodo(todo: TodoItem) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)

        do {
            let result = try context.fetch(fetchRequest)
            if let todoToEdit = result.first {
                todoToEdit.title = todo.title
                todoToEdit.todo = todo.todo
                todoToEdit.completed = todo.completed
                
                try context.save()
            }
        } catch {
            print("Error editing todo: \(error.localizedDescription)")
        }
    }
    
    func deleteTodo(_ todo: TodoItem) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)

        do {
            let result = try context.fetch(fetchRequest)
            if let todoToDelete = result.first {
                context.delete(todoToDelete)
                try context.save()
            }
        } catch {
            print("Error deleting todo: \(error.localizedDescription)")
        }
    }
    
    func saveContext(){
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                fatalError("Failed to update Context")
            }
        }
    }
}
