//
//  FieldKey+Extension.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Fluent

extension FieldKey {
    
    // MARK: - Dates
    static var createdAt: Self { "created_at" }
    static var updatedAt: Self { "updated_at" }
    static var deletedAt: Self { "deleted_at" }
    
    // MARK: - User
    static var email: Self { "email" }
    static var username: Self { "username" }
    static var avatarUrl: Self { "avatar_url" }
    static var value: Self { "value" }
    static var premiumExpAt: Self { "premium_exp_at" }
    static var role: Self { "role" }
    static var userId: Self { "user_id" }
    static var firebaseId: Self { "firebase_id" }
    static var wallet: Self { "wallet" }
    
    // MARK: - Device
    static var deviceUUID: Self { "device" }
    static var firebaseToken: Self { "fcm" }
    static var lastActive: Self { "last_active" }
    static var language: Self { "lang" }
    static var localization: Self { "localization" }
    
}

