//
//  AlertModel.swift
//  MapLocationRoute
//
//  Created by Konstantin Bolgar-Danchenko on 03.12.2022.
//

import Foundation
import UIKit

class AlertModel {
    
    static let shared = AlertModel()
    
    func showAlert(title: String, descr: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: descr, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default))
        UIApplication.topViewController()!.present(alert, animated: true)
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.connectedScenes
          .filter({$0.activationState == .foregroundActive})
          .compactMap({$0 as? UIWindowScene})
          .first?.windows
          .filter({$0.isKeyWindow})
          .first?.rootViewController) -> UIViewController? {

        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
