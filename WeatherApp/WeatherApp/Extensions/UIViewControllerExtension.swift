//
//  UIViewControllerExtension.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SwiftMessages

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
    
    func showLoader() {
        let loaderFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 60))
        let animationView = NVActivityIndicatorView(frame: loaderFrame, type: .ballClipRotateMultiple, color: UIColor.white, padding: 10)
        animationView.center = self.view.center
        self.view.addSubview(animationView)
        self.view.isUserInteractionEnabled = false
        animationView.startAnimating()
    }

    
    func hideLoader() {
        let animationView = self.view.subviews.filter({ $0.isKind(of: NVActivityIndicatorView.self) }).first as? NVActivityIndicatorView
        animationView?.stopAnimating()
        self.view.isUserInteractionEnabled = true
        animationView?.removeFromSuperview()
    }
    
    func showErrorMsg(errorMsg: String) {
        let errorView = MessageView.viewFromNib(layout: .cardView)
        errorView.button?.isHidden = true
        errorView.titleLabel?.text = "Error"
        errorView.configureTheme(.error)
        errorView.bodyLabel?.text = errorMsg
        SwiftMessages.show(view: errorView)
    }
}
