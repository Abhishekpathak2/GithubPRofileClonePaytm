//
//  UserModel.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import Foundation

struct UserModel: Codable {
    var login: String?
    var id: Int?
    var avatar_url: String?
    var name: String?
    var company: String?
    var bio: String?
    var followers: Int?
    var public_repos: Int?
    var following: Int?
    var message: String?
}
