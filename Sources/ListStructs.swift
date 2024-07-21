//
//  File.swift
//
//
//  Created by Mana Walsh on 2024-07-15
//

enum PriorityLevel: Encodable, Decodable {
    case Max
    case High
    case Med
    case Low
    case None
}

struct Task: Encodable, Decodable, Equatable {
    let name: String
    let priority: PriorityLevel
    
    static func fromString(_ name: String) -> Task {
        return Task(name: name, priority: .None)
    }
}

struct ToDoList: Encodable, Decodable {
    let name: String
    var tasks: [Task]
    var totalCompleted: Int
    
    func listContents(withExtraStats shouldPrintStats: Bool) {
        print("\(self.name):")
        if (self.tasks == []) { print("Your Gnu-Do list is empty. 🥳Hooray!🥳")}
        for task in self.tasks {
            print(task.name)
        }
        if (shouldPrintStats) {
            print("Tasks completed from \(self.name): \t\(self.totalCompleted)")
        }
    }
}
