//
//  ApiUtility.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import Foundation
import UIKit
protocol APIManager {
    func fetchUser(user: String, completionHandler: @escaping (_ status: Bool, _ result: UserModel?, _ error: String?) -> Void)
    func fetchUserRepo(user: String, completionHandler: @escaping (_ status: Bool, _ result: [UserRepoModel]?, _ error: String?) -> Void)
    func fetchContributors(user: String, reponame: String, completionHandler: @escaping (_ status: Bool, _ result: [ContributorModel]?, _ error: String?) -> Void)
}

class APIHandler: APIManager {
    
 func fetchUser(user: String, completionHandler: @escaping (Bool, UserModel?, String?) -> Void) {
        
            let url = "https://api.github.com/users/" + user
            let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
                guard let data = data, error == nil else{
                    completionHandler(false, nil, String(describing: error))
                    print("couldnt get user data")
                    return
                }
                
                var result: UserModel?
                
                do {
                    result = try JSONDecoder().decode(UserModel.self, from: data)
                    
                    if result?.message == nil {
                        completionHandler(true, result, nil)
                    } else if ((result?.message?.starts(with: "API")) != nil) {
                        guard let pathUrl = Bundle.main.url(forResource: "apidata", withExtension: "json") else {return}
                        
                        let url = URL(fileURLWithPath: pathUrl.path)
                        
                        do{
                            let jsonData = try Data(contentsOf: url)
                            result = try JSONDecoder().decode(UserModel.self, from: jsonData)
                            completionHandler(true, result, nil)
                            //print(result)
                        } catch {
                            completionHandler(false, nil, String(describing: error))
                        }
                    } else{
                        completionHandler(false, result, String(describing: error))
                    }
                    
                } catch {
                    completionHandler(false, nil, String(describing: error))
                }
            }
            task.resume()
        }
    func fetchUserRepo(user: String, completionHandler: @escaping (Bool, [UserRepoModel]?, String?) -> Void) {
        let url = "https://api.github.com/users/" + user + "/repos"
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else{
                print("couldnt get repo data")
                return
            }
            
            var result: [UserRepoModel]?
            
            do {
                result = try JSONDecoder().decode([UserRepoModel].self, from: data)
                completionHandler(true, result, nil)
            } catch {
                completionHandler(false, nil, String(describing: error))
            }
        }
        task.resume()
    }
    
    func fetchContributors(user: String, reponame: String, completionHandler: @escaping (Bool, [ContributorModel]?, String?) -> Void) {
        let url = "https://api.github.com/repos/" + user + "/" + reponame + "/contributors"
        let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else{
                print("couldnt get contributors data")
                return
            }
            
            var result: [ContributorModel]?
            
            do {
                result = try JSONDecoder().decode([ContributorModel].self, from: data)
                completionHandler(true, result, nil)
            } catch {
                completionHandler(false, nil, String(describing: error))
            }
        }
        task.resume()
    }
    
}
