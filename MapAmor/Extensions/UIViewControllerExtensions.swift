//
//  UIViewControllerExtensions.swift
//  MapAmor
//
//  Created by Bayu Yasaputro on 18/10/22.
//

import UIKit
import SafariServices

extension UIViewController {
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func openUrlInSafari(_ url: URL) {
        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true)
    }
}
