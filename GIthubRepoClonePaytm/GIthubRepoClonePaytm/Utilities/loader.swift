//
//  loader.swift
//  GIthubRepoClonePaytm
//
//  Created by Abhishek pathak on 04/08/22.
//


import UIKit

fileprivate var activityView: UIView?
extension UIViewController {
    func showSpinner() {
        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = UIColor.init(red: 255, green: 255, blue: 255, alpha: 1)
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.center = activityView!.center
        activityIndicator.startAnimating()
        activityView?.addSubview(activityIndicator)
        self.view.addSubview(activityView!)
      
    }
    func stopSpinner(){
        activityView?.removeFromSuperview()
        activityView = nil
    }
}


