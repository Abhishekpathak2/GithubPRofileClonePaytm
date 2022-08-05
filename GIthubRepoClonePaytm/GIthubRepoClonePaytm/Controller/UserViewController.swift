//
//  ViewController.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UserRepoProfileDelegate,UserProfileDelegate{

    @IBOutlet var SegmentView: UIView!
    @IBOutlet weak var SegmentController: UISegmentedControl!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var MainTableViewController: UITableView!
    @IBOutlet weak var collectionViewUser: UICollectionView!
    @IBOutlet weak var FollowBtn: UIButton!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var userid: UILabel!
    @IBOutlet weak var avatarImg: UIImageView!
    
    //MARK: VAriables
    let dataArray = ["Repositories", "Followers", "Following","Stars"]
    static let apiFetch = APIHandler()
    let UserViewModel = GitUserProfileViewModel(apiFetch: apiFetch)
    let UserRepoModel=UserRepoViewModel(apiFetch: apiFetch)
    var username:String=""
    var contributor:ContributorModel?
    var selectedIndex = -1
    //MARK: Activity Indicator VAriables
    var actView: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SegmentController.layer.borderWidth = 1.0
        SegmentController.layer.cornerRadius = 5.0
        SegmentController.layer.borderColor = UIColor.red.cgColor
        SegmentController.layer.masksToBounds = true
       
        //MARK: Delegates
        UserViewModel.delegate=self
        UserRepoModel.delegate=self
        
        //MARK: Activity Indicator
        showActivity(myView: self.view)
        
        //MARK: Fetch DATA Through ViewModel
        UserRepoModel.getRepoData(user: username)
        UserViewModel.fetchUser(user: username)
        
        //MARK: Data load
        avatarImg.downloaded(from: (UserViewModel.userData.avatar_url)!)
        Utils.roundImage(imageView: avatarImg)
        Username.text=UserViewModel.userData.name
        bio.text=UserViewModel.userData.bio
        userid.text="@\(Username.text ?? "Not Provided")"
        
        //MARK: HeaderSet
        MainTableViewController.tableHeaderView=headerView
        //MARK: collectionView Code
        collectionViewUser.register(userCollectionViewCell.nib(), forCellWithReuseIdentifier: userCollectionViewCell.identifier)
        collectionViewUser.dataSource=self
        collectionViewUser.delegate=self
        
        //MARK: TableView Code
        MainTableViewController.register(RepoTableViewCell.nib(), forCellReuseIdentifier: RepoTableViewCell.identifier)
        MainTableViewController.delegate=self
        MainTableViewController.dataSource=self
        
    }
    //MARK: Protocols
    
    func didFinishFetchingRepoData() {
        DispatchQueue.main.async {
            self.stopSpinner()
        }
      
        print("did fetch")
    }
    
    func didNotFetchRepoData() {
        DispatchQueue.main.async {
            self.stopSpinner()
        }
        print("Not fetched")
    }
    
    
    func didFinishFetchingUserData() {
        DispatchQueue.main.async {
            self.stopSpinner()
            self.MainTableViewController.reloadData()
        }
    }
    
    func didNotFetchUserData() {
        DispatchQueue.main.async {
            self.stopSpinner()
        }
        print("Not fetched")
       
    }
    
    func UserNotFound() {
        DispatchQueue.main.async {
            self.stopSpinner()
        }
        print("User Not Found")
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.removeActivity(myView: self.view)
            self.MainTableViewController.reloadData()
        }
    }
    
    
}
//MARK: collectionView Functions

extension UserViewController {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex =  indexPath.row
        collectionView.reloadData()
        collectionView.deselectItem(at: indexPath, animated: true)
    }
 
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userCollectionViewCell.identifier, for: indexPath as IndexPath) as! userCollectionViewCell
        if indexPath.row == 0 {
            cell.configure(dataName: dataArray[indexPath.row], dataCount: UserViewModel.userData.public_repos ?? 0)
        } else if indexPath.row == 1 {
            cell.configure(dataName: dataArray[indexPath.row], dataCount: UserViewModel.userData.followers ?? 0)
        } else if indexPath.row==2{
            cell.configure(dataName: dataArray[indexPath.row], dataCount: UserViewModel.userData.following ?? 0)
        }else{
            cell.configure(dataName: dataArray[indexPath.row], dataCount: ((UserViewModel.userData.public_repos!+UserViewModel.userData.followers!+UserViewModel.userData.following!)/4))
        }
        if selectedIndex == indexPath.row {
            cell.layer.cornerRadius=25
            cell.backgroundColor =  UIColor.tertiarySystemFill
         }
        else{
            cell.layer.cornerRadius=0
            cell.backgroundColor = UIColor.systemBackground
        }
        return cell
    }
    //MARK: userInfo collectionView delegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellCount = dataArray.count
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(cellCount - 1))
        let cellSize = ((collectionView.bounds.width) - cellSpace) / CGFloat(cellCount)
        return CGSize(width: cellSize, height: collectionView.bounds.height)
    }
    
    
}
//MARK: TableView Functions
extension UserViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0)
        {
            return 97
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return collectionViewUser
        }
        
        return SegmentView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section==0
        {
            return 0
        }
        return UserRepoModel.repoData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MainTableViewController.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier, for: indexPath) as! RepoTableViewCell
        cell.configure(with: UserRepoModel.repoData[indexPath.row])
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 20
        cell.layer.borderWidth = 0.5
        cell.layer.shadowOffset = CGSize(width: 4, height: 1)
        let borderColor=UIColor.systemMint
        cell.layer.borderColor = borderColor.cgColor
        cell.selectionStyle = .none
        cell.backgroundColor=UIColor.systemBackground
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let contributorVC = self.storyboard?.instantiateViewController(withIdentifier:"CVC") as! ContributorViewController
        contributorVC.title = "Contributors"
        contributorVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeTapped))
        contributorVC.username = UserViewModel.userData.login
        contributorVC.reponame = UserRepoModel.repoData[indexPath.section].name
        self.navigationController?.pushViewController(contributorVC, animated: true)

    }
    
    @objc func homeTapped(){
        
        self.navigationController?.popToViewController(of: UserViewController.self, animated: true)
    }

    //MARK: func for table Activity indicator
    func showActivity(myView: UIView) {
        myView.isUserInteractionEnabled = false
        myView.window?.isUserInteractionEnabled = false
        myView.endEditing(true)
        actView.frame = CGRect(x: 0, y: 0, width: myView.frame.width, height: myView.frame.height)
        actView.center = myView.center
        actView.backgroundColor = UIColor.white
     
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = myView.center
        loadingView.backgroundColor = UIColor.white
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 15

        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0);
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);


        loadingView.addSubview(activityIndicator)
        actView.addSubview(loadingView)
 
        myView.addSubview(actView)
        activityIndicator.startAnimating()
    }
    func removeActivity(myView: UIView) {
        myView.isUserInteractionEnabled = true
        myView.window?.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
        actView.removeFromSuperview()
    }
}




//MARK: Extension View
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {return }
            DispatchQueue.main.async() { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.image = image
            }
        }.resume()
       
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        self.activityIndicator.startAnimating()
        guard let url = URL(string: link) else {
            return }
        downloaded(from: url, contentMode: mode)
    }
    fileprivate var activityIndicator: UIActivityIndicatorView {
    get {

        if let indicator = self.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
            return indicator
        }

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        self.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        let centerX = NSLayoutConstraint(item: self,
                                         attribute: .centerX,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerX,
                                         multiplier: 1,
                                         constant: 0)

        let centerY = NSLayoutConstraint(item: self,
                                         attribute: .centerY,
                                         relatedBy: .equal,
                                         toItem: activityIndicator,
                                         attribute: .centerY,
                                         multiplier: 1,
                                         constant: 0)

        self.addConstraints([centerX, centerY])
        return activityIndicator
      }
    }
}


