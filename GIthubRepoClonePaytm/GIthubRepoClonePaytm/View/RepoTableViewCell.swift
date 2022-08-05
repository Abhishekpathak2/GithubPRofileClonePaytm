//
//  RepoTableViewCell.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var repoImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var bottomstack: UIStackView!

    @IBOutlet weak var repoForks: UILabel!
    @IBOutlet weak var repoStars: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var repoStarButton: UIButton!
    @IBOutlet weak var repoLastUpdated: UILabel!
    @IBOutlet weak var publiOrPrivate: UIImageView!
    
    static let identifier="pinnedCell"
    static func nib()->UINib{
        return UINib(nibName: "RepoTableViewCell", bundle: nil)
    }
    let defaultLabel = "Not Provided"
    func configure(with repoData:UserRepoModel){
        repoName.text = "\(repoData.name ?? defaultLabel)"
        repoDescription.text =  repoData.description ?? defaultLabel
        repoLanguage.text = "🟠 \(repoData.language ?? defaultLabel)"
        repoStars.text = "⭐\( Utils.short(repoData.stargazers_count ?? 0)) repos"
        repoForks.text = "\(Utils.short(repoData.forks ?? 0)) forks"
        repoLastUpdated.text = Utils.dateDifference(repoDate: repoData.updated_at ?? "")
        repoStarButton.layer.cornerRadius = 5
        repoImage.downloaded(from: "https://cdn-icons-png.flaticon.com/512/25/25231.png")
        Utils.roundImage(imageView: repoImage) //MARK: to make image in the cell circular
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        }
}

