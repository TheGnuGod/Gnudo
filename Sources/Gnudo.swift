//
// Gnudo.swift
//
//
// Created by Mana Walsh on 2024-07~15
//

import Foundation
import ArgumentParser

@main struct Gnudo: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A To-Do list app with a name pertaining to wildebeest.", 
        version: "v0.0.1",
        subcommands: [List.self, Add.self, Check.self, Remove.self, Clear.self],
        defaultSubcommand: List.self)
    
    struct List: ParsableCommand {
        mutating func run() throws  {
            let fm = FileManager()
            let jsonifier = JSONEncoder()
            let structifier = JSONDecoder()
            jsonifier.outputFormatting = .prettyPrinted
            let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
            prepGnudoJson(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: [], totalCompleted: 0))
      
            // Read & Load the data
            let workingData = try structifier.decode(ToDoList.self, from: fm.contents(atPath: dataPath)!)
        
            // Manipulate the data
            workingData.listContents()
           
            // Write the data
            let finalData = try jsonifier.encode(workingData)
            fm.createFile(atPath: dataPath, contents: finalData)
        }
    }
    
    struct Add: ParsableCommand {
        
        static var configuration: CommandConfiguration
        = CommandConfiguration(abstract: "Add a new element to the list.")
        
        @Argument var name: String
        
        mutating func run() throws {
            let fm = FileManager()
            let jsonifier = JSONEncoder()
            let structifier = JSONDecoder()
            jsonifier.outputFormatting = .prettyPrinted
            let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
            prepGnudoJson(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: [], totalCompleted: 0))
            
            
            // Read & Load the data
            var workingData: ToDoList
            do {
                workingData = try structifier.decode(ToDoList.self, from: fm.contents(atPath: dataPath)!)
            } catch {
                fatalError("Failed to decode JSON data")
            }
            
            // Manipulate the data
            workingData.tasks.append(Task.fromString(name))
            
            // Write the data
            let finalData = try jsonifier.encode(workingData)
            fm.createFile(atPath: dataPath, contents: finalData)
        }
    }
    
    struct Check: ParsableCommand {
        
    }
    
    struct Remove: ParsableCommand {
        
    }

    struct Clear: ParsableCommand {
        mutating func run() {
            let fm = FileManager()
            let jsonifier = JSONEncoder()
            let structifier = JSONDecoder()
            jsonifier.outputFormatting = .prettyPrinted
            let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
            prepGnudoJson(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "The Gnudo List", tasks: [], totalCompleted: 0))
            
            // Read & Load the data
            var workingData: ToDoList
            do {
                workingData = try structifier.decode(ToDoList.self, from: fm.contents(atPath: dataPath)!)
            } catch {
                fatalError("Failed to read JSON data. from \(dataPath)")
            }
            
            // Manipulate the data
            workingData.tasks = []
            
            // Write the data
            let finalData: Data
            do {
                finalData = try jsonifier.encode(workingData)
            } catch {
                fatalError("Failed to encode JSON. Any actions performed here will not be saved.")
            }
            fm.createFile(atPath: dataPath, contents: finalData)
        }
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
