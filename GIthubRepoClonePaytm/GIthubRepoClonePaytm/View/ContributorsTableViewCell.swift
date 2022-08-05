//
//  userCollectionViewCell.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import UIKit
class ContributorsTableViewCell: UITableViewCell {

    @IBOutlet weak var contributorNameLabel: UILabel!
    @IBOutlet weak var contributorImageView: UIImageView!
    @IBOutlet weak var contributorContributionsLabel: UILabel!
    
    static let identifier = "ContributorsTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with contriModel: ContributorModel?){
        
        contributorNameLabel.text = contriModel?.login
        contributorContributionsLabel.text = "Contributions: \(contriModel?.contributions ?? 0)"
        contributorImageView.downloaded(from: (contriModel?.avatar_url)!)
        Utils.roundImage(imageView: contributorImageView)
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ContributorsTableViewCell", bundle: nil)
    }
}
