//
//  PresentationManager.swift
//  CoinDoc
//
//  Created by Aswin S on 15/11/24.
//

import UIKit

/// manager class for presenting above view controller
class PresentationManager {
    
    /// Presents a popover view controller
    /// - Parameters:
    ///   - presentingVC: View controller from which the popover will be presented
    ///   - popoverVC: View controller to present as a popover
    ///   - sourceView: View to use as the anchor point for the popover
    ///   - preferredContentSize: Preferred size for the popover content
    static func presentPopover(from presentingVC: UIViewController,
                        popoverVC: UIViewController,
                        sourceView: UIView,
                        preferredContentSize: CGSize) {
        
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = preferredContentSize
        
        // Configure the popover source and anchor point
        if let popoverPresentationController = popoverVC.popoverPresentationController {
            popoverPresentationController.sourceView = sourceView
            popoverPresentationController.sourceRect = sourceView.bounds
            popoverPresentationController.permittedArrowDirections = .any
            popoverPresentationController.delegate = presentingVC as? UIPopoverPresentationControllerDelegate
        }
        
        presentingVC.present(popoverVC, animated: true, completion: nil)
    }
    
    /// Presents an alert with a title, message, and customisable actions
    /// - Parameters:
    ///   - presentingVC: View controller from which the alert will be presented
    ///   - title: Title of the alert
    ///   - message: Message body of the alert
    ///   - actions: Actions to display on the alert
    ///   - preferredStyle: Style of the alert
    static func presentAlert(from presentingVC: UIViewController,
                             title: String,
                             message: String,
                             actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)],
                             preferredStyle: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { alertController.addAction($0) }
        presentingVC.present(alertController, animated: true, completion: nil)
    }
}
