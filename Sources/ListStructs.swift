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

extension String {
    func representedPriorityLevel() -> Task.PriorityLevel {
        switch self.uppercased() {
        case "MAX":
            return .Max
        case "HIGH":
            return .High
        case "MED":
            return .Medium
        case "LOW":
            return .Low
        case "":
            return .None
        case "NONE":
            return .None
        default:
            print("Failed to interpret priority level.")
            exit(1)
        }
    }
}

enum enumCaseRepresentation {
    case Abbrev
    case FullName
    case Emoji
}

struct Task: Encodable, Decodable, Equatable {
    enum PriorityLevel: Encodable, Decodable, Hashable {
        case Max
        case High
        case Medium
        case Low
        case None
        
        func representation(inFormat format: enumCaseRepresentation) -> String {
            switch format {
            case .Emoji:
                switch self {
                case .Max:
                    return "🟥"
                case .High:
                    return "🟧"
                case .Medium:
                    return "🟨"
                case .Low:
                    return "🟩"
                case .None:
                    return "⬜️"
                }
            case .Abbrev:
                switch self {
                case .Max:
                    return "Max"
                case .High:
                    return "High"
                case .Medium:
                    return "Med"
                case .Low:
                    return "Low"
                case .None:
                    return "Unprioritised"
                }
            case .FullName:
                switch self {
                case .Max:
                    return "Maximum"
                case .High:
                    return "High"
                case .Medium:
                    return "Medium"
                case .Low:
                    return "Low"
                case .None:
                    return "None"
                }
            }
            
        }
        
        static let arrayOfAllCases: [Self] = [.Max,.High,.Medium,.Low,.None]
    }
    
    let name: String
    let priority: PriorityLevel
}

struct ToDoList: Encodable, Decodable {
    let name: String
    var tasks: [Task]
    
    var taskCompletionStats: [Task.PriorityLevel:Int] =
        [.Max:0,
         .High:0,
         .Medium:0,
         .Low:0,
         .None:0]
    
    mutating func checkOff(_ name: String, shouldIncrementTaskCounter incrementing: Bool) {
        var i: Int = 0
        for task in self.tasks {
            if (task.name == name) {
                self.tasks.remove(at: i)
                if (!incrementing) { break }
                self.taskCompletionStats[task.priority]! += 1
            }
            i += 1;
        }
    }
    
    func listContents(withExtraStats shouldPrintStats: Bool) {
        print("\(self.name):")
        if (self.tasks == []) { print("Your Gnu-Do list is empty. 🥳Hooray!🥳")}
        for task in self.tasks {
            print(task.priority.representation(inFormat: .Emoji), terminator: "")
            print(task.name)
        }
        if (shouldPrintStats) {
            print("\nTask Completion Statistics:")
            for priorityLevel in Task.PriorityLevel.arrayOfAllCases {
                print("\(priorityLevel.representation(inFormat: .Emoji))\(taskCompletionStats[priorityLevel]!) \(priorityLevel.representation(inFormat: .FullName)) \t priority task(s)")
            }
            let totalCompleted: Int = {
                var runningTotal: Int = 0
                for priorityLevel in Task.PriorityLevel.arrayOfAllCases {
                    runningTotal += taskCompletionStats[priorityLevel]!
                }
                return runningTotal
            }()
            print("\n👏 In total that's ✨\(totalCompleted)✨ tasks! 👏")
        }
    }
    
    
}

extension [Task] {
    func hasTaskWithName(_ name: String) -> Bool{
        for task in self {
            if (task.name == name) {
                return true
            }
        }
        
        return false
    }
}
