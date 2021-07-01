//
//  DetailAlbumViewController.swift
//  Music
//
//

import UIKit
import Firebase

class DetailAlbumViewController: UIViewController {
    
    var trackList = [Tracklist]()
    var master = [MasterAlbum]()
    var releases = [ReleasesAlbum]()
    
    var id: Int = 0
    var type: String = ""
    var name: String = ""
    var artist: String = ""

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var trackListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Asignar el nombre del artista al titulo
        self.title = name
        
        // Tipo de Album
        if self.type == "master" {
            self.albumMaster(id: id)
            self.infoLabel.text = "Año de lanzamiento · \(String(master[0].year ?? 0000)) \nGenero · \(master[0].genres?[0] ?? "Sin genero")"
        } else {
            self.albumRelease(id: id)
            self.infoLabel.text = "Año de lanzamiento · \(String(releases[0].year ?? 0000)) \nGenero · \(releases[0].genres?[0] ?? "Sin genero")"
        }
    }
    
    func albumMaster(id: Int){
        let urlString = "https://api.discogs.com/masters/\(id)"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        
        func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonPeticion = try? decoder.decode(MasterAlbum.self, from: json) {
                master = [jsonPeticion]
                
                // Añadimos las canciones al arreglo TrackList
                for i in master {
                    for j in i.tracklist{
                        trackList.append(j)
                    }
                }
            }
        }
    }
    
    func albumRelease(id: Int){
        let urlString = "https://api.discogs.com/releases/\(id)"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        
        func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonPeticion = try? decoder.decode(ReleasesAlbum.self, from: json) {
                releases = [jsonPeticion]
                
                // Añadimos las canciones al arreglo TrackList
                for i in releases {
                    for j in i.tracklist{
                        trackList.append(j)
                    }
                }
            }
        }
    }
    
    @IBAction func favoriteButton(_ sender: UIBarButtonItem) {
        if self.type == "master" {
            let user = Auth.auth().currentUser
            if let user = user {
                let email = user.email
                let id = self.master[0].id
                let name = self.master[0].title!
                let year = self.master[0].year
                let type = self.type
                let genres = self.master[0].genres?[0] ?? "Sin genero"
                let artist = self.artist
                let db = Firestore.firestore()
                db.collection(email!).document().setData(["id": id ?? 1, "name": name, "year": year ?? 0000, "type": type, "genres": genres, "artist": artist])
            }
            
            let alert = UIAlertController(title: "Listo", message: "\(master[0].title!) se añadio correctamente a tu lista de favoritos", preferredStyle: .alert)
            
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                            
            // Agregar acciones al alert
            alert.addAction(actionAcept)
            
            // Mostramos el alert
            self.present(alert, animated: true, completion: nil)
        } else {
            let user = Auth.auth().currentUser
            if let user = user {
                let email = user.email
                let id = self.releases[0].id!
                let name = self.releases[0].title!
                let year = self.releases[0].year!
                let genres = self.releases[0].genres?[0] ?? "Sin genero"
                let artist = self.artist
                let db = Firestore.firestore()
                db.collection(email!).document().setData(["id": id, "name": name, "year": year , "type": type, "genres": genres, "artist": artist])
            }
            
            let alert = UIAlertController(title: "Listo", message: "\(releases[0].title!) se añadio correctamente a tu lista de favoritos", preferredStyle: .alert)
            
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                            
            // Agregar acciones al alert
            alert.addAction(actionAcept)
            
            // Mostramos el alert
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: Metodos UITableView
extension DetailAlbumViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = trackListTableView.dequeueReusableCell(withIdentifier: "cellTracklist", for: indexPath)
        celda.textLabel?.text = "\(trackList[indexPath.row].position!)   \(trackList[indexPath.row].title!)"
        celda.detailTextLabel?.text = "Duracion: \(trackList[indexPath.row].duration!)"

        // Cambiar tamaño de la fuente en la celda
        celda.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        celda.detailTextLabel?.font = UIFont.systemFont(ofSize: 12.0)
        return celda
    }
}
