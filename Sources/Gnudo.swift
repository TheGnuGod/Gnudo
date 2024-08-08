/*
    Gnudo.swift
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

import Foundation
import ArgumentParser

@main struct Gnudo: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A To-Do list app with a name pertaining to wildebeest.", 
        version: "v0.2.0",
        subcommands: [List.self, Add.self, Check.self, Clear.self],
        defaultSubcommand: List.self)
    
    struct List: ParsableCommand {
        static var configuration: CommandConfiguration
        = CommandConfiguration(abstract: "List the tasks in the current Gnu-Do list.")
       
        @Flag(name: .customShort("s"), help: "Show extra statistics, like the total amount of tasks checked off from the current list.") var includeExtraStats: Bool = false
        
        mutating func run() {
            let fm = FileManager()
            let jsonifier = JSONEncoder()
            let structifier = JSONDecoder()
            jsonifier.outputFormatting = .prettyPrinted
            let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
            prepJsonLocation(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: []))
      
            // Read & Load the data
            let workingData = loadToDoList(fromJsonAt: dataPath, usingFileManager: fm, andDecoder: structifier)
        
            // Manipulate the data
            workingData.listContents(withExtraStats: includeExtraStats)
           
            // Write the data
            saveToDoList(workingData, to: dataPath, usingFileManager: fm, andEncoder: jsonifier)
        }
    }
    
    struct Add: ParsableCommand {
        
        static var configuration: CommandConfiguration
        = CommandConfiguration(abstract: "Add a new element to the list.")
        
        @Argument(help: "The name of the task to add.") var name: String
        @Argument(help: "The priority level of the task to add. Use max, high, med, low or leave blank for none.") var priorityLevelName: String = ""
        
        mutating func run() {
            let priorityToSet = priorityLevelName.representedPriorityLevel()
            let fm = FileManager()
            let jsonifier = JSONEncoder()
            let structifier = JSONDecoder()
            jsonifier.outputFormatting = .prettyPrinted
            let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
            prepJsonLocation(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: []))
            
            
            // Read & Load the data
            var workingData: ToDoList = loadToDoList(fromJsonAt: dataPath, usingFileManager: fm, andDecoder: structifier)
            
            // Manipulate the data
            if (workingData.tasks.hasTaskWithName(name)) {
                print("There is already a task with that name on the list. Did not modify data."); return
            }
            workingData.tasks.append(Task(name: name, priority: priorityToSet))
            
            // Write the data
            saveToDoList(workingData, to: dataPath, usingFileManager: fm, andEncoder: jsonifier)
        }
    }
    
    struct Check: ParsableCommand {
        static var configuration: CommandConfiguration
        = CommandConfiguration(abstract: "Check off a task from the current Gnu-Do list.")
        
        @Argument(help: "The name of the task to remove") var nameToRemove: String
        @Flag(name: .customShort("n"), help: "Do not increment the task counter when removing tasks with this flag.") var leaveNoTrace: Bool = false
        
        mutating func run() {
            let fm = FileManager()
            let jsonifier = JSONEncoder()
            let structifier = JSONDecoder()
            jsonifier.outputFormatting = .prettyPrinted
            let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
            prepJsonLocation(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: []))
      
            // Read & Load the data
            var workingData = loadToDoList(fromJsonAt: dataPath, usingFileManager: fm, andDecoder: structifier)
        
            // Manipulate the data
            workingData.checkOff(nameToRemove, shouldIncrementTaskCounter: !leaveNoTrace)
            
            // Write the data
            saveToDoList(workingData, to: dataPath, usingFileManager: fm, andEncoder: jsonifier)
        }
    }
    
    struct Clear: ParsableCommand {
        static var configuration: CommandConfiguration
        = CommandConfiguration(abstract: "Remove every element from the current list, with no trace.")
        
        @Flag(name: .customShort("i"), help: "When enabled, increment the completed task counter for each task in the list.") var shouldIncrementTaskStats: Bool = false
        
        mutating func run() {
            let fm = FileManager()
            let jsonifier = JSONEncoder()
            let structifier = JSONDecoder()
            jsonifier.outputFormatting = .prettyPrinted
            let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
            prepJsonLocation(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: []))
            
            // Read & Load the data
            var workingData: ToDoList = loadToDoList(fromJsonAt: dataPath, usingFileManager: fm, andDecoder: structifier)
                        
            // Manipulate the data
            if (!shouldIncrementTaskStats) {
                workingData.tasks = []
            }
            for task in workingData.tasks {
                workingData.checkOff(task.name, shouldIncrementTaskCounter: true)
            }
                        
            // Write the data
            saveToDoList(workingData, to: dataPath, usingFileManager: fm, andEncoder: jsonifier)
        }
    }
}
