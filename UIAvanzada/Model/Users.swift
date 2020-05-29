//
//  Users.swift
//  UIAvanzada
//
//  Created by David Rabassa Planas on 28/05/2020.
//  Copyright © 2020 David Rabassa. All rights reserved.
//

import Foundation

struct UsersListResponse: Codable {
    let directoryItems: [Users]
    enum CodingKeys: String, CodingKey {
        case directoryItems = "directory_items"
    }
}

struct Users: Codable {
    let user: User
    
}

struct User: Codable {
    let username: String
    let name: String?
    let avatarTemplate: String
    
    enum CodingKeys: String, CodingKey {
        case avatarTemplate = "avatar_template"
        case username
        case name
    }
}
