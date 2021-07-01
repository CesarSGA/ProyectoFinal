//
//  CaratulaPortraitCollectionViewCell.swift
//  OnBoarding
//
//  Created by Jose Angel Cortes Gomez on 26/06/21.
//

import UIKit

class CaratulaPortraitCollectionViewCell: UICollectionViewCell {

    static let identifier = "CaratulaPortraitCollectionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var caratulaImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playcountLabel: UILabel!
    
    func setup(album: Album) {
        let img = "https://i.pinimg.com/originals/18/de/c6/18dec6114dcfbccef7d425449a2cbb29.png"
        titleLabel.text = album.name
        caratulaImageView.kf.setImage(with: img.asUrl)
        artistLabel.text = album.artist.name
        playcountLabel.text = album.artist.playcount
    }
}
