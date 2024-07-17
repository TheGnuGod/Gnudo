//
//  File.swift
//
//
//  Created by Mana Walsh on 15/07/2024.
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
