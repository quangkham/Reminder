//
//  ToDoList.swift
//  ToDo_Note
//
//  Created by TechFun on 23/03/2020.
//  Copyright © 2020 TechFunMyanmar. All rights reserved.
//

import Foundation
import CoreData

public class ToDoList : NSManagedObject , Identifiable {
    
    @NSManaged public var createdAt : Date
    @NSManaged public var task : String
    @NSManaged public var id : UUID
    @NSManaged public var status : String
    @NSManaged public var priority  :String
    
    var taskStatus : Status {
        set {
            status = newValue.rawValue
        }
        get {
            Status(rawValue: status) ?? .pending
        }
    }
}


enum Status : String
{
    case pending = "Pending"
    case inProgress = "In Progress"
    case done = "Done"
}
