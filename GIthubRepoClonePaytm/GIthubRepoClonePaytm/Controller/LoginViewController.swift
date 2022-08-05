//
//  LoginViewController.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import UIKit

class LoginViewController: UITableViewController,UserProfileDelegate{


    static let apiFetch = APIHandler()
    let userData = GitUserProfileViewModel(apiFetch: apiFetch)
    @IBOutlet weak var LoginIDTxtBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userData.delegate=self
}
   //MARK: login btn
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let username = LoginIDTxtBox.text, !username.isEmpty, !username.contains(" ") else {return}
        self.showSpinner()
        userData.fetchUser(user: username)

    }
    //MARK: Protocols
    func didFinishFetchingUserData() {
        DispatchQueue.main.async {
            self.stopSpinner()
            let UVC = self.storyboard?.instantiateViewController(withIdentifier: "UVC") as! UserViewController
           UVC.UserViewModel.userData  = self.userData.userData
            UVC.username=self.LoginIDTxtBox.text!
            
            self.navigationController?.pushViewController(UVC, animated: true)
        }
    }
    func didNotFetchUserData() {
        DispatchQueue.main.async {
            let NF=self.storyboard?.instantiateViewController(withIdentifier: "NF")as! NotFetchedViewController
            NF.text="Data Not Fetched!!"
            self.navigationController?.pushViewController(NF, animated: true)
        }
    }
    func UserNotFound() {
        DispatchQueue.main.async {
        let EVC=self.storyboard?.instantiateViewController(withIdentifier: "EVC")as! ErrorViewController
        EVC.text="User Not Found!!"
        self.navigationController?.pushViewController(EVC, animated: true)    }
    }
    
    //MARK: TableView Functions
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    
    
}
