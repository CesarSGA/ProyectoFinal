//
//  String+Extension.swift
//  OnBoarding
//
//

import Foundation

// MARK: Formato para converir strings en URL y capitalizarlos
extension String {
    var asUrl : URL?{
        return URL(string: self)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
