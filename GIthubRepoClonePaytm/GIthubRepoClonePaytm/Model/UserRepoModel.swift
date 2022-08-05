//
//  UserRepoModel.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import Foundation

struct UserRepoModel: Decodable {
    var name: String?
    var visibility: String?
    var description: String?
    var language: String?
    var forks: Int?
    var stargazers_count: Int?
    var updated_at: String?
    var topics: [String]?
    var message: String?
}
