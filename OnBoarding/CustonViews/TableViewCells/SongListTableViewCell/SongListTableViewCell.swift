//
//  SongListTableViewCell.swift
//  OnBoarding
//
//  Created by Jose Angel Cortes Gomez on 26/06/21.
//

import UIKit

class SongListTableViewCell: UITableViewCell {
    
    static let identifier = "SongListTableViewCell"

    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    func setup(song: Track) {
        let img = "https://i.pinimg.com/originals/18/de/c6/18dec6114dcfbccef7d425449a2cbb29.png"
        songImageView.kf.setImage(with: img.asUrl)
        titleLabel.text = song.name
        artistLabel.text = song.artist.name
    }
}
