//
//  Repository.swift
//  AndroidRepos
//
//  Created by Marc Jardine Esperas on 2/24/22.
//

import Foundation

struct Repository: Decodable {

    
    let name: String?
    let description: String?
    let owner: Owner?
    let stars: Int?
    let watchers: Int?
    let forks: Int?

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case owner
        case stars = "stargazers_count"
        case watchers = "watchers_count"
        case forks = "forks_count"
    }
}

struct Owner: Decodable {
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}

extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.name == rhs.name && lhs.description == rhs.description && lhs.owner?.avatarURL == rhs.owner?.avatarURL && lhs.stars == rhs.stars && lhs.watchers == rhs.watchers && lhs.forks == rhs.forks
    }
}
