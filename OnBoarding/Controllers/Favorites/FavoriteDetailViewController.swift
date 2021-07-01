//
//  FavoriteDetailViewController.swift
//  OnBoarding
//
//

import UIKit

class FavoriteDetailViewController: UIViewController {

    var trackList = [Tracklist]()
    var resultadosMaster = [MasterAlbum]()
    var resultadosReleases = [ReleasesAlbum]()
    
    var id: Int?
    var name: String?
    var year: Int?
    var type: String?
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var trackListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Asignar el nombre del artista al titulo
        self.title = name
        
        // Tipo de Album
        switch self.type {
        case "master":
            self.albumMaster(id: id!)
            self.infoLabel.text = "Año de lanzamiento · \(String(resultadosMaster[0].year ?? 0000)) \nGenero · \(resultadosMaster[0].genres?[0] ?? "Sin genero")"
        case "release":
            self.albumRelease(id: id!)
            self.infoLabel.text = "Año de lanzamiento · \(String(resultadosReleases[0].year ?? 0000)) \nGenero · \(resultadosReleases[0].genres?[0] ?? "Sin genero")"
        default:
            let alert = UIAlertController(title: "Error", message: "Lo sentimos actualmente \(self.name ?? "N/A") no se encuentra disponible intente mas tarde.", preferredStyle: .alert)
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(actionAcept)
            self.present(alert, animated: true, completion: nil)
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
                resultadosMaster = [jsonPeticion]
                
                // Añadimos las canciones al arreglo TrackList
                for i in resultadosMaster {
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
                resultadosReleases = [jsonPeticion]
                
                // Añadimos las canciones al arreglo TrackList
                for i in resultadosReleases {
                    for j in i.tracklist{
                        trackList.append(j)
                    }
                }
            }
        }
    }
}

//MARK: Metodos UITableView
extension FavoriteDetailViewController: UITableViewDelegate, UITableViewDataSource{
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
