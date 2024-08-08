/*
    DataInteraction.swift
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

func prepJsonLocation(atPath path: String, usingFileManager fm: FileManager, maxAttempts: Int = 3, encoder: JSONEncoder, andDefaultList list: ToDoList) {
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
