//
//  DetallesArtistaViewController.swift
//  Music
//
//

import UIKit

class DetailArtistViewController: UIViewController {
    
    var releases = [Releases]()
    var detailArtist =  [DetailArtist]()

    var id = 0
    var name  = ""
    var cover_image: String = ""
    var resource_url: String = ""
    var profile: String = ""

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var releasesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileArtist(id: id)
        
        // Asignar el nombre del artista al titulo
        self.aboutLabel.text = "Acerca de \(name)"
        if profile != ""{
            self.infoLabel.text = profile
        } else {
            self.infoLabel.text = "N/A"
        }
        
        // Cargamos la imagen disponible del Artista
        let url = NSURL(string: cover_image)
        let dataImge = NSData(contentsOf : url! as URL)
        if((dataImge) != nil){
            self.artistImageView.image = UIImage(data : dataImge! as Data)
        } else {
            let url = NSURL(string: "https://i.pinimg.com/564x/af/96/fb/af96fb76ec66e466193f266e32732f7b.jpg")
            let dataImge = NSData(contentsOf : url! as URL)
            self.artistImageView.image = UIImage(data : dataImge! as Data)
        }
        self.searchReleasesArtists(id: id)
    }
    
    func searchReleasesArtists(id: Int){
        let urlString = "https://api.discogs.com/artists/\(id)/releases?sort_order=desc"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        
        func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonPeticion = try? decoder.decode(ReleasesArtist.self, from: json) {
                releases = jsonPeticion.releases
            }
        }
        // Recargamos la TableView
        DispatchQueue.main.async {
            self.releasesTableView.reloadData()
        }
    }
    
    func profileArtist(id: Int){
        let urlString = "https://api.discogs.com/artists/\(id)"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        
        func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonPeticion = try? decoder.decode(DetailArtist.self, from: json) {
                detailArtist = [jsonPeticion]
                
                if detailArtist[0].profile == "" {
                    detailArtist[0].profile = "N/A"
                }
                self.profile = detailArtist[0].profile
            }
        }
    }
}

//MARK: Metodos UITableView
extension DetailArtistViewController: UITableViewDelegate, UITableViewDataSource{
    func hideCellTableView() {
        if releasesTableView.visibleCells.count == 0 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: releasesTableView.bounds.size.width, height: releasesTableView.bounds.size.height))
            label.text = "Actualmente no contamos con la discografia"
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.sizeToFit()
            releasesTableView.backgroundView = label
            releasesTableView.separatorStyle = .none
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.hideCellTableView()
        return releases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = String(releases[indexPath.row].type!)
        let celda = releasesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        celda.textLabel?.text = releases[indexPath.row].title!
        
        // Cambiar tamaño de la fuente en la celda
        celda.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        celda.detailTextLabel?.font = UIFont.systemFont(ofSize: 12.0)
        
        // Definir el tipo (Cancion o Album)
        switch type {
        case "master":
            celda.detailTextLabel?.text = "Album - \(String(releases[indexPath.row].year ?? 0000))"
        case "release":
            celda.detailTextLabel?.text = "Sencillo - \(String(releases[indexPath.row].year ?? 0000))"
        default:
            print("error")
        }
        return celda
    }
    
    // Envio de datos por el Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "segueDetailsAlbum", let destination = segue.destination as? DetailAlbumViewController, let releaseIndex = releasesTableView.indexPathForSelectedRow?.row {
            destination.id = releases[releaseIndex].id ?? 0
            destination.type = releases[releaseIndex].type ?? "N/A"
            destination.name = releases[releaseIndex].title ?? "N/A"
            destination.artist = name
        }
    }
}
