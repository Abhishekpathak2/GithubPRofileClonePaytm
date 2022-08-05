//
//  uesrRepoViewModel.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 03/08/22.
//

import Foundation
protocol UserRepoProfileDelegate{
    func didFinishFetchingRepoData()
    func didNotFetchRepoData()
    func reload()
}
class UserRepoViewModel{
    // MARK: Stored Properties
    var delegate: UserRepoProfileDelegate? //MARK: UserProfileDelegate refernce
    var apiFetch: APIManager? //MARK: APIMANAGER Protocol reference
   
    var repoData = [UserRepoModel](){
        didSet{
            
            self.delegate?.reload()
        }
    } //MARK: to store repositries data
    
    
    init(apiFetch: APIManager){
        self.apiFetch = apiFetch
    }
    
    
    // MARK: Updating user data
 
    func getRepoData(user: String){
        apiFetch?.fetchUserRepo(user: user) { [self] status, result, error in
            if status == true {
                if let result = result {
                    
                    self.repoData = result
                  
                    //repoData.append(contentsOf: self.repoData)
                    self.delegate?.didFinishFetchingRepoData()
                }
                
            }else{
                self.delegate?.didNotFetchRepoData()
            }
        }
        
    }
    
}





