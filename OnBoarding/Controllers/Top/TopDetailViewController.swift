//
//  TopDetailViewController.swift
//  OnBoarding
//
//  Created by Jose Angel Cortes Gomez on 26/06/21.
//

import UIKit

class TopDetailViewController: UIViewController {

    @IBOutlet weak var caratulaImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playcountLabel: UILabel!
    
    var artist: Artist!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = artist.name
        popularView()
    }
    
    private func popularView() {
        caratulaImageView.kf.setImage(with: artist.url.asUrl)
        descriptionLabel.text = "Reproducciones: \(artist.listeners ?? "N/A")"
        playcountLabel.text = "Oyentes: \(artist.playcount ?? "N/A")"
    }
}
