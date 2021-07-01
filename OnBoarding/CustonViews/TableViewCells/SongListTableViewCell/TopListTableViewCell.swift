//
//  CaratulaListTableViewCell.swift
//  OnBoarding
//
//  Created by Jose Angel Cortes Gomez on 26/06/21.
//

import UIKit

class CaratulaListTableViewCell: UITableViewCell {
    
    static let identifier = "CaratulaListTableViewCell"
    
    @IBOutlet weak var caratulaImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setup(caratula: DishCategory) {
        caratulaImageView.kf.setImage(with: caratula.image?.asUrl)
        titleLabel.text = caratula.name
        descriptionLabel.text = caratula.name
    }
    
}
