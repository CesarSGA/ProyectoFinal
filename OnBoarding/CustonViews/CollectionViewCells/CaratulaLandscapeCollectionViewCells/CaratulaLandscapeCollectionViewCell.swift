//
//  CaratulaLandscapeCollectionViewCell.swift
//  OnBoarding
//
//  Created by Jose Angel Cortes Gomez on 26/06/21.
//

import UIKit

class CaratulaLandscapeCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: CaratulaLandscapeCollectionViewCell.self)
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var caratulaImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playcountLabel: UILabel!

    func setup(artist: Artist) {
        let img = "https://i.pinimg.com/564x/af/96/fb/af96fb76ec66e466193f266e32732f7b.jpg"
        titleLabel.text = artist.name
        caratulaImageView.kf.setImage(with: img.asUrl)
        artistLabel.text = "Reproducciones: \(String(describing: artist.listeners! ))"
        playcountLabel.text = "Oyentes: \(String(describing: artist.playcount! ))"
    }
}
