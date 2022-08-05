//
//  ErrorViewController.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 02/08/22.
//

import UIKit

class ErrorViewController: UIViewController {
    
    @IBOutlet weak var UILabel: UILabel!
    var text: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UILabel.text = text
    }
    
}
