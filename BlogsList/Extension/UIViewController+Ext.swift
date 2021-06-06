//
//  UIViewController+Ext.swift
//  BlogsList
//
//  Created by Ali Jawad on 30/05/2021.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            
        }
        alertController.addAction(OKAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

@objc extension UIViewController: View {
    func showError(title: String, message: String) {
        alert(title, message: message)
    }
    
    func loadingActivity(loading: Bool) {
        fatalError("Loading error method is not implemented")
    }
    
    
}
 
