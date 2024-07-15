//
//  File.swift
//  
//
//  Created by Mana Walsh on 15/07/2024.
//

import Foundation

struct Task: Encodable {
    let name: String
}

struct ToDoList: Encodable {
    let name: String
    var tasks: [Task]
}
