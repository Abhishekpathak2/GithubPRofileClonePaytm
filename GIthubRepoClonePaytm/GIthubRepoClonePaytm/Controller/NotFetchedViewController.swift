//
//  NotFetchedViewController.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 03/08/22.
//

import UIKit

class NotFetchedViewController: UIViewController {

    @IBOutlet weak var UILabelTExt: UILabel!
    var text: String!
    override func viewDidLoad() {
       
        super.viewDidLoad()
        UILabelTExt.text=text
    }
    
}
