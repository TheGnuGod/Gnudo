//
//  File.swift
//
//
//  Created by Mana Walsh on 2024-07-15
//

import Foundation

enum PriorityLevel: Encodable {
    case Max
    case High
    case Med
    case Low
}

struct Task: Encodable {
    let name: String
    let priority: PriorityLevel?
}

struct ToDoList: Encodable {
    let name: String
    var tasks: [Task]
}
