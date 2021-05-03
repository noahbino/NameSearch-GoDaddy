//
//  UIViewController+Extension.swift
//  NameSearch
//
//  Created by Noah Iarrobino on 5/2/21.
//  Copyright © 2021 GoDaddy Inc. All rights reserved.
//

import UIKit

extension UIViewController {
    private func present(_ dismissableAlert: UIAlertController) {
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel)
        dismissableAlert.addAction(dismissAction)
        present(dismissableAlert, animated: true)
    }
    
    func presentAlert(with message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        present(alert)
    }
    
    func present(_ error: Error) {
        presentAlert(with: error.localizedDescription)
    }
}


