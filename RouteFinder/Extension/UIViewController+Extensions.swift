//
//  UIViewControllerExtensions.swift
//  RouteFinder
//
//  Created by Basil Mariano on 5/3/20.
//  Copyright © 2020 Panfilo Mariano Jr. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: Text.alertTitle,
                                             message: message,
                                             preferredStyle: .alert)
        let okayAction = UIAlertAction(title: Text.ok, style: .default, handler: nil)
        alertController.addAction(okayAction)

        present(alertController, animated: true, completion: nil)

    }
}
