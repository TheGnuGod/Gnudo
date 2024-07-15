//
// main.swift
//
// Created by Mana Walsh on 15/07/2024.
//

import Foundation
import ArgumentParser

@main struct Gnudo: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "A To-Do list app with a name pertaining to wildebeest.", version: "v0.0.1")
    static let dataPath: String = "~/.gnudodata.json"
   
    mutating func run() throws  {
        let fm = FileManager()
        if (!fm.fileExists(atPath: Gnudo.dataPath)) {
            print("There is no data file at the expected loacation.")
            print("Creating \(Gnudo.dataPath)")
            fm.createFile(atPath: Gnudo.dataPath, contents: nil)
        }
   }
}
