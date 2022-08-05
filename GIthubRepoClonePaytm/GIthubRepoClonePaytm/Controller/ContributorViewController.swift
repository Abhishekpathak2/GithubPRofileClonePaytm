//
//  ContributorViewController.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 03/08/22.
//

import UIKit

class ContributorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,ContributorDelegate ,UserProfileDelegate{
    
    @IBOutlet weak var contributorsTableView: UITableView!
    
    //MARK: Variables
    var username:String?
    var reponame:String?
    static let apiFetch = APIHandler()
    let userData = GitUserProfileViewModel(apiFetch: apiFetch)
    var contributorViewModel=ContributorViewModel(apiFetch:apiFetch)
    var usernamesee:String = "leondz"
    
    override func viewDidLoad() {
        //MARK: Delegates
        contributorViewModel.delegate=self
        userData.delegate=self
        
        super.viewDidLoad()
        
        //MARK: Contributormodel delegate and register
        contributorViewModel.fetchContributorData(user: username!, repoName: reponame!)
        contributorsTableView.register(ContributorsTableViewCell.nib(), forCellReuseIdentifier: ContributorsTableViewCell.identifier)
        contributorsTableView.delegate = self
        contributorsTableView.dataSource = self
        
        //MARK: Activity indicator
        self.showSpinner()
    }
    
    //MARK: Protocols
    
    func reload() {
        DispatchQueue.main.async {
            self.stopSpinner()
            self.contributorsTableView.reloadData()
        }
    }
    
    func didNotFinishFetchingContributorData() {
        DispatchQueue.main.async {
            self.stopSpinner()
        }
        print("didnotfetchContributors")
    }
    
    func didFinishFetchingContributorData() {
        DispatchQueue.main.async {
            self.stopSpinner()
        }
        print("fetched")
    }
    
    func didNotFetchUserData() {
        DispatchQueue.main.async {
            self.stopSpinner()
            let EVC = self.storyboard?.instantiateViewController(withIdentifier: "EVC") as! ErrorViewController
            EVC.title = "Not Found"
            EVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(self.homeTapped))
            self.navigationController?.pushViewController(EVC, animated: true)
        }
    }
    
    func UserNotFound() {
        DispatchQueue.main.async {
            self.stopSpinner()
        }
        print("")
    }
    func didFinishFetchingUserData() {
        DispatchQueue.main.async {
            self.stopSpinner()
            let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UVC") as! UserViewController
            userVC.title = self.usernamesee
            userVC.username=self.usernamesee
            userVC.UserViewModel.userData=self.userData.userData
            
            userVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(self.homeTapped))
            self.navigationController?.pushViewController(userVC, animated: true)
        }
    }
    
    //MARK: Home tapped wrapper
    
    @objc func homeTapped(){
        self.navigationController?.popToViewController(of: UserViewController.self, animated: true)
    }
    
}
//MARK: TableView Functions
extension ContributorViewController{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        usernamesee=self.contributorViewModel.contributorData[indexPath.row].login
        userData.fetchUser(user: usernamesee)
        contributorsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributorViewModel.contributorData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = contributorsTableView.dequeueReusableCell(withIdentifier: ContributorsTableViewCell.identifier, for: indexPath) as! ContributorsTableViewCell
        cell.configure(with: contributorViewModel.contributorData[indexPath.row])
        return cell
    }
}




