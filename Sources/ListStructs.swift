/*
    ListStructs.swift
    Created on 2024-07-15
 
    Gnudo, a terminal-based to-do list app with a name pertaining to wildebeest.
    Copyright (C) 2024 Mana Walsh

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

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
