//
//  ContributorModel.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import Foundation
    
    struct ContributorModel: Decodable {
        let login: String
        let avatar_url: String?
        let contributions: Int?
        let message: String?
    }
