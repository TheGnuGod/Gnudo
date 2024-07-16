//
// main.swift
//
// Created by Mana Walsh on 15/07/2024.
//

import Foundation
import ArgumentParser

@main struct Gnudo: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "A To-Do list app with a name pertaining to wildebeest.", version: "v0.0.1")
   
    mutating func run() throws  {
        let fm = FileManager()
        let dataPath: String = String("\(fm.homeDirectoryForCurrentUser).gnudodata.json".dropFirst(7))
        ensureGnudoJsonfile(atPath: dataPath, withMaxAttemps: 3, usingFileManager: fm)
       
    }
}

func ensureGnudoJsonfile(atPath path: String, withMaxAttemps maxAttempts: Int, usingFileManager fm: FileManager) {
    var fileCreationLoopCount: Int = 0
        while (!fm.fileExists(atPath: path) && fileCreationLoopCount < maxAttempts) {
            print("There is no data file at the expected loacation.")
            print("Creating \(path)...")
            fm.createFile(atPath: "",contents: nil)
            fileCreationLoopCount += 1
        }
        if (!fm.fileExists(atPath: path)) {
            fatalError("Failed to create \(path) after \(maxAttempts) attempts. Aborting execution.")
        } else { print("Successfully created datafile.")}

}
