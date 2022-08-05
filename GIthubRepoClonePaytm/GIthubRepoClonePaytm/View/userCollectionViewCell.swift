//
//  userCollectionViewCell.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import UIKit

class userCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var dataCountLabel: UILabel!
    @IBOutlet weak var dataNameLabel: UILabel!
    static let identifier = "collectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(dataName: String, dataCount: Int){
        dataCountLabel.text = "\(Utils.short(dataCount))"
        dataNameLabel.text = dataName
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "userCollectionViewCell", bundle: nil)
    }
}
