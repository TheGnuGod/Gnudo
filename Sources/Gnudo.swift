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
        version: "v0.1.0",
        subcommands: [List.self, Add.self, Check.self, Clear.self],
        defaultSubcommand: List.self)
    
    struct List: ParsableCommand {
        static var configuration: CommandConfiguration
        = CommandConfiguration(abstract: "List the tasks in the current Gnu-Do list.")
       
        @Flag(name: .customShort("s"), help: "Show extra statistice, like the total amount of tasks checked off from the current list.") var includeExtraStats: Bool = false
        
        mutating func run() {
            let fm = FileManager()
            let jsonifier = JSONEncoder()
            let structifier = JSONDecoder()
            jsonifier.outputFormatting = .prettyPrinted
            let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
            prepGnudoJson(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: [], totalCompleted: 0))
      
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
        
        @Argument var name: String
        
        mutating func run() {
            let fm = FileManager()
            let jsonifier = JSONEncoder()
            let structifier = JSONDecoder()
            jsonifier.outputFormatting = .prettyPrinted
            let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
            prepGnudoJson(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: [], totalCompleted: 0))
            
            
            // Read & Load the data
            var workingData: ToDoList = loadToDoList(fromJsonAt: dataPath, usingFileManager: fm, andDecoder: structifier)
            
            // Manipulate the data
            if (!workingData.tasks.contains(Task.fromString(name))) {
                workingData.tasks.append(Task.fromString(name))
            } else {
                print("There is already a task with that name on the list. Did not modify data"); return
            }
            
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
            prepGnudoJson(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: [], totalCompleted: 0))
      
            // Read & Load the data
            var workingData = loadToDoList(fromJsonAt: dataPath, usingFileManager: fm, andDecoder: structifier)
        
            // Manipulate the data
            var i: Int = 0
            for task in workingData.tasks {
                if (task.name == nameToRemove) {
                    workingData.tasks.remove(at: i)
                    workingData.totalCompleted += leaveNoTrace ? 0 : 1
                    continue
                }
                i += 1;
            }
            
            // Write the data
            saveToDoList(workingData, to: dataPath, usingFileManager: fm, andEncoder: jsonifier)
        }
    }
    
    struct Clear: ParsableCommand {
        static var configuration: CommandConfiguration
        = CommandConfiguration(abstract: "Remove every element from the current list, with no trace.")
        
        @Flag(name: .customShort("i"), help: "When enabled, increment the completed task counter for each task in the ist.") var incrementTaskCounter: Bool = false
        
        mutating func run() {
            let fm = FileManager()
            let jsonifier = JSONEncoder()
            let structifier = JSONDecoder()
            jsonifier.outputFormatting = .prettyPrinted
            let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
            prepGnudoJson(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: [], totalCompleted: 0))
            
            // Read & Load the data
            var workingData: ToDoList = loadToDoList(fromJsonAt: dataPath, usingFileManager: fm, andDecoder: structifier)
                        
            // Manipulate the data
            workingData.totalCompleted += incrementTaskCounter ? workingData.tasks.count : 0
            workingData.tasks = []
            
            // Write the data
            saveToDoList(workingData, to: dataPath, usingFileManager: fm, andEncoder: jsonifier)
        }
    }
}

func loadToDoList(fromJsonAt path: String, usingFileManager fm: FileManager, andDecoder structifer: JSONDecoder) -> ToDoList {
    
    do {
        return try structifer.decode(ToDoList.self, from: fm.contents(atPath: path)!)
    } catch DecodingError.dataCorrupted {
        fatalError("The JSON data at \(path) has been corrupted or is otherwise invalid. Aborting execution.")
    } catch {
        fatalError("Failed to decode data at \(path). Aborting execution.")
    }
}

func saveToDoList(_ input: ToDoList, to path: String, usingFileManager fm: FileManager, andEncoder jsonifier: JSONEncoder) {
    do {
         try fm.createFile(atPath: path, contents: jsonifier.encode(input))
    } catch EncodingError.invalidValue {
        fatalError("A JSON encoder used to save the data after the performed operation was passed an invalid value. Any actions performed this command will not be saved. Aborting execution.")
    } catch {
        fatalError("Failed to encode JSON data to save data after the performed operation. Any actions performed this command will not be saved. Aborting execution.")
    }
}

func prepGnudoJson(atPath path: String, usingFileManager fm: FileManager, maxAttempts: Int = 3, encoder: JSONEncoder, andDefaultList list: ToDoList) {
    if (fm.fileExists(atPath: path)) { return }
    
    let listData = try! encoder.encode(list)
    
    var fileCreationAttemps = 1
    while (!fm.fileExists(atPath: path) && fileCreationAttemps <= maxAttempts) {
        print("There is not a data file at the expected location.")
        print("Creating \(path)... (Attempt \(fileCreationAttemps))")
        fm.createFile(atPath: path, contents: listData)
        fileCreationAttemps += 1
    }
    if (fm.fileExists(atPath: path)) { print((fileCreationAttemps == 1) ? "Successfully created data file!" : "Created the datafile! (🎉!First Try!🎉)"); return }
    fatalError("Failed to create data file at '\(path)'. Abort.")
}
