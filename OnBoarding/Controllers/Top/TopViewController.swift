//
//  TopViewController.swift
//  OnBoarding
//
//

import UIKit
import WebKit
import SafariServices

class TopViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var popularCollectionView: UICollectionView!
    @IBOutlet weak var artistCollectionView: UICollectionView!
    
    var categories = [Tag]()
    var albums = [Album]()
    var artists = [Artist]()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getCategories()
        topAlbums()
        topArtists()
        registerCells()
    }
    
    private func registerCells(){
        categoryCollectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        popularCollectionView.register(UINib(nibName: CaratulaPortraitCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CaratulaPortraitCollectionViewCell.identifier)
        artistCollectionView.register(UINib(nibName: CaratulaLandscapeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CaratulaLandscapeCollectionViewCell.identifier)
    }
    
    // MARK: Funciones para obtener los datos de la API
    func getCategories() {
        let apiKey = "85b04280e810869b7e663889c4dd2d81"
        let urlString = "https://ws.audioscrobbler.com/2.0/?method=chart.gettoptags&tag=disco&limit=10&api_key=\(apiKey)&format=json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonPeticion = try? decoder.decode(TagsCategory.self, from: json) {
                categories = jsonPeticion.tags.tag
            }
        }
    }
    
    func topAlbums(){
        let apiKey = "85b04280e810869b7e663889c4dd2d81"
        let urlString = "https://ws.audioscrobbler.com/2.0/?method=tag.gettopalbums&tag=disco&limit=10&api_key=\(apiKey)&format=json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonPeticion = try? decoder.decode(TopAlbums.self, from: json) {
                albums = jsonPeticion.albums.album
            }
        }
    }
    
    func topArtists(){
        let apiKey = "85b04280e810869b7e663889c4dd2d81"
        let urlString = "https://ws.audioscrobbler.com/2.0/?method=chart.gettopartists&limit=10&api_key=\(apiKey)&format=json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonPeticion = try? decoder.decode(TopArtist.self, from: json) {
                artists = jsonPeticion.artists.artist
            }
        }
    }
}

// MARK: Metodos del CollectionView
extension TopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return categories.count
        case popularCollectionView:
            return albums.count
        case artistCollectionView:
            return artists.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.setup(category: categories[indexPath.row])
            return cell
        case popularCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaratulaPortraitCollectionViewCell.identifier, for: indexPath) as! CaratulaPortraitCollectionViewCell
            cell.setup(album: albums[indexPath.row])
            return cell
        case artistCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CaratulaLandscapeCollectionViewCell.identifier, for: indexPath) as! CaratulaLandscapeCollectionViewCell
            cell.setup(artist: artists[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoryCollectionView:
            let controller = ListTopViewController.instantiate()
            controller.category = categories[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        case popularCollectionView:
            let urlDirection = albums[indexPath.row].url
            let safariVC = SFSafariViewController(url: URL(string: urlDirection)!)
            present(safariVC, animated: true)
        case artistCollectionView:
            let urlDirection = artists[indexPath.row].url
            let safariVC = SFSafariViewController(url: URL(string: urlDirection)!)
            present(safariVC, animated: true)
        default:
            let urlDirection = "https://www.last.fm/home"
            let safariVC = SFSafariViewController(url: URL(string: urlDirection)!)
            present(safariVC, animated: true)
        }
    }
}
