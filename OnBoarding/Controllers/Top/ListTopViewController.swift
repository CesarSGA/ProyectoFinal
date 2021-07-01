//
//  ListTopViewController.swift
//  OnBoarding
//
//

import UIKit
import WebKit
import SafariServices

class ListTopViewController: UIViewController {
    
    var category: Tag!
    var songs = [Track]()

    @IBOutlet weak var topListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = category.name?.capitalizingFirstLetter()
        tagSongs()
        registerCells()
    }

    private func registerCells() {
        topListTableView.register(UINib(nibName: SongListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SongListTableViewCell.identifier)
    }
    
    // MARK: Funcion para obtener los datos de la API
    func tagSongs(){
        let tag = category.name
        let tagFormat = String(tag!.replacingOccurrences(of: " ", with: "+"))
        let apiKey = "85b04280e810869b7e663889c4dd2d81"
        let urlString = "https://ws.audioscrobbler.com/2.0/?method=tag.gettoptracks&tag=\(tagFormat)&limit=25&api_key=\(apiKey)&format=json"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonPeticion = try? decoder.decode(TagsTrack.self, from: json) {
                songs = jsonPeticion.tracks.track
            }
        }
    }
}

// MARK: Metodos del TableView
extension ListTopViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = topListTableView.dequeueReusableCell(withIdentifier: SongListTableViewCell.identifier) as! SongListTableViewCell
        cell.setup(song: songs[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlDirection = songs[indexPath.row].url
        let safariVC = SFSafariViewController(url: URL(string: urlDirection)!)
        present(safariVC, animated: true)
    }
}
