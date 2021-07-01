//
//  ArtistListTableViewCell.swift
//  OnBoarding
//
//  Created by Jose Angel Cortes Gomez on 26/06/21.
//

import UIKit

class ArtistListTableViewCell: UITableViewCell {

    static let identifier = "ArtistListTableViewCell"

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(artist: Results) {
        let img = "https://i.pinimg.com/originals/18/de/c6/18dec6114dcfbccef7d425449a2cbb29.png"
        artistImageView.kf.setImage(with: img.asUrl)
        artistLabel.text = artist.title
//        titleLabel.text = artist.|
    }
}
