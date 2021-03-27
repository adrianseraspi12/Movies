//
//  ViewController+Extensions.swift
//  Movies
//
//  Created by Adrian Jun Seraspi on 3/27/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String,
                   message: String,
                   action: String,
                   callback: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: action, style: .default, handler: callback))
        self.present(alert, animated: true, completion: nil)
    }
    
}
