//
//  GithubViewModel.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import Foundation
protocol UserProfileDelegate{
    func didFinishFetchingUserData()
    func didNotFetchUserData()
    func UserNotFound()
}

class GitUserProfileViewModel{
    // MARK: Stored Properties
    var delegate: UserProfileDelegate? //MARK: UserProfileDelegate refernce
    var apiFetch: APIManager? //MARK: APIMANAGER Protocol reference
    var userData = UserModel() //MARK: to store user data
    
    let userInfoTexts = ["repositories", "stars", "followers", "following"]
    
    init(apiFetch: APIManager){
        self.apiFetch = apiFetch
    }
    
    
    // MARK: Updating user data
    func fetchUser(user: String){
        apiFetch?.fetchUser(user: user) { [self] status, result, error in
            if status == true {
                if let result = result {
                    self.userData = result
                    delegate?.didFinishFetchingUserData()
                } else if ((result?.message?.starts(with: "API")) != nil){
                    self.delegate?.didNotFetchUserData()
                } else{
                    self.delegate?.UserNotFound()
                }
            }
        }
    }
    
    
    
    
    
}
