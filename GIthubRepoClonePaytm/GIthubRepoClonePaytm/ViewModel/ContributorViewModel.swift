//
//  ContributorViewModel.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import Foundation


protocol ContributorDelegate{
    func didFinishFetchingContributorData()
    func didNotFinishFetchingContributorData()
    func reload()
}

class ContributorViewModel{
    var contributorData = [ContributorModel](){
        didSet{
            self.delegate?.reload()
        }
    }
    var delegate: ContributorDelegate?
    var contributors: APIManager?
    var errorInfetchingContributors = false
    
    init(apiFetch: APIManager){
        contributors = apiFetch
    }
    
    // MARK: updating contributors data
    func fetchContributorData(user: String, repoName: String){
        contributors?.fetchContributors(user: user, reponame: repoName, completionHandler: { status, data, error in
            if let data = data {
                self.errorInfetchingContributors = false
                self.contributorData = data
                self.delegate?.didFinishFetchingContributorData()
            } else{
                self.errorInfetchingContributors = true
                self.delegate?.didNotFinishFetchingContributorData()
            }
        })
    }
}
