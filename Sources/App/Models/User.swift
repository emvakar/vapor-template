//
//  User.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Vapor
import Fluent
import FJWTMiddleware

final class User: Model, Content {

    static func builder(db: Database) -> QueryBuilder<User> {
        return User.query(on: db)
            .with(\.$wallet)
    }

    static let schema = "users"

    @ID(custom: .id)
    var id: Int?

    /// firebase id
    @Field(key: .firebaseId)
    var firebaseId: String

    @Field(key: .email)
    var email: String
    
    @Field(key: .username)
    var username: String?
    
    @Field(key: .avatarUrl)
    var avatarUrl: String?

    @OptionalEnum(key: .role)
    var role: Role?

    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?
    
    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?
    
    // MARK: - Relations

    @OptionalChild(for: \.$user)
    var wallet: Wallet?

    init() { }
    
    init(id: User.IDValue? = nil, firebaseId: String, email: String, username: String?, avatarUrl: String?) {
        self.id = id
        self.firebaseId = firebaseId
        self.email = email
        self.username = username
        self.avatarUrl = avatarUrl
    }
    
    init(from: FJWTPayload) {
        self.firebaseId = from.userID
        self.email = from.email ?? "anonymous"
        self.username = (from.email ?? "anonymous").components(separatedBy: "@").first ?? (from.email ?? "anonymous")
        self.avatarUrl = nil
    }
    
    final class Public: Content {
        
        let id: User.IDValue
        let email: String
        let username: String?
        let registeredAt: Date?
        let avatar_url: String?
        var cashback: Int = 0
        
        init(id: User.IDValue, _ user: User) {
            self.id = id
            self.email = user.email
            self.username = user.username
            self.registeredAt = user.createdAt
            self.avatar_url = user.avatarUrl

            if let value = user.wallet {
                self.cashback += value.value
            }
        }
        
        final class Smart: Content {
            let id: User.IDValue
            let username: String?
            let avatar_url: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case username
                case avatar_url
            }
            
            init(id: User.IDValue, email: String, username: String?, avatar_url: String?) {
                self.id = id
                self.username = username
                self.avatar_url = avatar_url
            }
            
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                id = try container.decode(User.IDValue.self, forKey: .id)
                username = try container.decodeIfPresent(String.self, forKey: .username)
                avatar_url = try container.decodeIfPresent(String.self, forKey: .avatar_url)
            }
            
            init(user: User) {
                self.id = user.id!
                self.username = user.username
                self.avatar_url = user.avatarUrl
            }
        }
    }
}

extension User {

    func toPublic() -> User.Public {
        return User.Public(id: id!, self)
    }

    func convertToSmart() -> User.Public.Smart {
        return User.Public.Smart(user: self)
    }

}

extension EventLoopFuture where Value: User {

    func convertToPublic() -> EventLoopFuture<User.Public> {
        return self.map { user in
            return user.toPublic()
        }
    }

    func convertToSmart() -> EventLoopFuture<User.Public.Smart> {
        return self.map { user in
            return user.convertToSmart()
        }
    }

}

extension Collection where Element: User {

    func convertToPublic() -> [User.Public] {
        return self.map { $0.toPublic() }
    }

    func convertToSmart() -> [User.Public.Smart] {
        return self.map { $0.convertToSmart() }
    }

}

extension EventLoopFuture where Value == Array<User> {

    func convertToPublic() -> EventLoopFuture<[User.Public]> {
        return self.map { $0.convertToPublic() }
    }

    func convertToSmart() -> EventLoopFuture<[User.Public.Smart]> {
        return self.map { $0.convertToSmart() }
    }

}

