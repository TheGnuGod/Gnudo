//
// Gnudo.swift
//
//
// Created by Mana Walsh on 2024-07~15
//

import Foundation
import ArgumentParser

@main struct Gnudo: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "A To-Do list app with a name pertaining to wildebeest.", version: "v0.0.1")
    mutating func run() throws  {
        let fm = FileManager()
        let jsonifier = JSONEncoder()
        jsonifier.outputFormatting = .prettyPrinted
        let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
        prepGnudoJson(atPath: dataPath, usingFileManager: fm, encoder: jsonifier, andDefaultList: ToDoList(name: "Gnudo List", tasks: []))
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
