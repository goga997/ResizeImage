//
//  UIViewController+Extension.swift
//  DiTatiCuVladu
//
//  Created by Grigore on 05.07.2023.
//

import UIKit

extension UIViewController {
    
    func photoLibraryAccesAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    
}
