//
//  TodoEntity+CoreDataProperties.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//
//

import Foundation
import CoreData


extension TodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
        return NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    }

    @NSManaged public var userId: Int64
    @NSManaged public var todo: String?
    @NSManaged public var title: String?
    @NSManaged public var id: Int64
    @NSManaged public var date: Date?
    @NSManaged public var completed: Bool

}

extension TodoEntity : Identifiable {

}
