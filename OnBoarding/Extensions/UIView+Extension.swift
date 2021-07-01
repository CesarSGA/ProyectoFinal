//
//  UIView+Extension.swift
//  OnBoarding
//
//

import UIKit

// MARK: Añadir la propiedad en los atributos de un elemento
extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
