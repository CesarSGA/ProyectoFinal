//
//  CategoryCollectionViewCell.swift
//  OnBoarding
//
//  Created by Jose Angel Cortes Gomez on 26/06/21.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CategoryCollectionViewCell.self)

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    func setup(category: Tag){
        let img = "https://i.pinimg.com/originals/8c/a6/dd/8ca6dde4aca09fad23e3b9ac8e0220bb.jpg"
        categoryImageView.kf.setImage(with: img.asUrl)
        categoryTitleLabel.text = category.name?.capitalizingFirstLetter()
    }
}
