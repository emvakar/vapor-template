//
//  Request+Extension.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Vapor
import Fluent
import FJWTMiddleware

extension Request {

    func user(userId: User.IDValue? = nil) async throws -> User {

        guard let userId = userId else {
            let payload = try await firebaseJwt.verify()
            let user = try await User.builder(db: db)
                            .filter(\.$firebaseId == payload.userID)
                            .first()
            guard let user = user else {
                let user = User(from: payload)
                _ = try await user.create(on: db)
                let userId = try user.requireID()
                let wallet = Wallet(userId: userId, value: 0)
                try await user.$wallet.create(wallet, on: db)
                return try await self.user(userId: userId)
            }
            return user
        }
    
        let user = try await User.builder(db: db)
                        .filter(\.$id == userId)
                        .first()
        guard let user = user else {
            throw Abort(.notFound)
        }
        return user
    }
    
    @discardableResult
    func fileWrite(at path: String, oldFile: String? = nil, file: File? = nil, delete: Int? = nil) async throws -> String? {

        guard let payloadFile = file, (delete == nil || delete == 0) else {
            
            if let oldFile = oldFile?.components(separatedBy: "/").last {
                
                let deleteUrl = URL(fileURLWithPath: path).appendingPathComponent(oldFile, isDirectory: false)
                try? FileManager.default.removeItem(at: deleteUrl)

            }
            return nil
        }
        
        guard let fileExtension = payloadFile.extension else {
            throw Abort(.badRequest, reason: "Error with reading file extension")
        }
        let fileName = "\(UUID().uuidString.lowercased()).\(fileExtension)"

        let saveURL = URL(fileURLWithPath: path).appendingPathComponent(fileName, isDirectory: false)

        if let oldFile = oldFile?.components(separatedBy: "/").last {

            let deleteUrl = URL(fileURLWithPath: path).appendingPathComponent(oldFile, isDirectory: false)
            try? FileManager.default.removeItem(at: deleteUrl)
        
        }
        
        do {
            let bufferData = payloadFile.data
            let data = Data(buffer: bufferData)
            try data.write(to: saveURL)
            return "/" + fileName
        } catch {
            logger.critical("Unable to write multipart form data to file. Underlying error \(error)")
            throw Abort(.internalServerError, reason: "Unable to write multipart form data to file.")
        }
    }
    
}
