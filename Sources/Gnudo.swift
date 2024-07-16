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
        let maxDataFileCreationTries:Int = 3
       
        var fileCreationLoopCount: Int = 0
        while (!fm.fileExists(atPath: dataPath) && fileCreationLoopCount < maxDataFileCreationTries) {
            print("There is no data file at the expected loacation.")
            print("Creating \(dataPath)...")
            fm.createFile(atPath: "",contents: nil)
            fileCreationLoopCount += 1
        }
        if (!fm.fileExists(atPath: dataPath)) {
            fatalError("Failed to create \(dataPath) after \(maxDataFileCreationTries) attempts. Aborting execution.")
        } else { print("Successfully created datafile.")}
    }
}
