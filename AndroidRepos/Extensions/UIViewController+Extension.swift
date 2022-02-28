//
//  UIViewController+Extension.swift
//  AndroidRepos
//
//  Created by Marc Jardine Esperas on 2/24/22.
//

import UIKit

extension UIViewController {

    func showAlert(title: String = "",
                   message: String,
                   buttonText: String = "Close",
                   style: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        let action = UIAlertAction(title: buttonText, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func addBackButton() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
}
