//
//  folders.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Vapor

@discardableResult
func createFolderIfNotExist(on app: Application, _ folderName: String) throws -> String {
    var isDir: ObjCBool = true
    let path = app.directory.publicDirectory.appending(folderName).lowercased()
    if !FileManager.default.fileExists(atPath: path, isDirectory: &isDir) {
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
    }
    return path
}
