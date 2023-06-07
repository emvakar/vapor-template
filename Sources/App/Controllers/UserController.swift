//
//  UserController.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Fluent
import Vapor

struct UserController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("api", "v1", "users")
        users.get("profile", use: profile)
        users.get(["profile", ":userId"], use: profile)
        users.put(["profile", "avatar"], use: uploadAvatar)
    }

    func registerUser(req: Request) async throws -> User {
        return try await req.user()
    }

    func profile(_ req: Request) async throws -> User.Public {
        
        if let userId = req.parameters.get("userId", as: User.IDValue.self) {
            return try await req.user(userId: userId).toPublic()
        }
        
        return try await registerUser(req: req).toPublic()
    }

    func uploadAvatar(_ req: Request) async throws -> User.Public {
        
        let user = try await req.user()
        
        let folderName = "users"
        let path = try createFolderIfNotExist(on: req.application, folderName)
        
        struct Input: Content {
            var file: File?
            var delete: Int?
        }
        
        let payload = try req.content.decode(Input.self)
        
        let imageUrl = try await req.fileWrite(at: path, oldFile: user.avatarUrl, file: payload.file, delete: payload.delete)
        
        if let imageUrl = imageUrl {
            user.avatarUrl = "/\(folderName)\(imageUrl)"
        } else {
            user.avatarUrl = nil
        }
        try await user.update(on: req.db)
        
        return user.toPublic()
    }

}

