//
//  SearchViewController.swift
//  OnBoarding
//
//

import UIKit

class SearchViewController: UIViewController {

    var artist = [Results]()
    var detailArtist = [DetailArtist]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var artistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ocultamos las celdas de la TableView
        self.hideCellTableView()
    }
    
    func hideCellTableView() {
        if artistTableView.visibleCells.count == 0 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: artistTableView.bounds.size.width, height: artistTableView.bounds.size.height))
            label.text = ""
            label.textColor = UIColor.black
            label.textAlignment = .center
            label.sizeToFit()
            artistTableView.backgroundView = label
            artistTableView.separatorStyle = .none
        }
    }
    
    func searchArtist(query: String){
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let key = "xqFaAoQEtxUaCuDiEeKS"
        let secret = "xRuowAoDhPUsaLkZQSbmYzNcOxoqDrUL"
        let urlString = "https://api.discogs.com/database/search?q=\(query!)&type=artist&title=\(query!)&key=\(key)&secret=\(secret)"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            }
        }
        
        func parse(json: Data) {
            let decoder = JSONDecoder()
            if let jsonPeticion = try? decoder.decode(ResultsArtist.self, from: json) {
                artist = jsonPeticion.results
            }
        }
        // Recargamos la TableView
        DispatchQueue.main.async {
            self.artistTableView.reloadData()
        }
    }
}

//MARK: Metodos UISearchBar
extension SearchViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(SearchViewController.reload), object: nil)
        self.perform(#selector(SearchViewController.reload), with: nil, afterDelay: 0.5)
        
        if searchText.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                searchBar.resignFirstResponder()
                self.artist = []
                // Recargamos la TableView
                DispatchQueue.main.async {
                    self.artistTableView.reloadData()
                }
                // Ocultamos las celdas de la TableView
                self.hideCellTableView()
            }
        } else {
            // Llamado a la funcion para buscar al artista
            self.searchArtist(query: searchText)
        }
    }
    
    // Ocultar teclado al dar click en buscar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    @objc func reload() {
        guard searchBar.text != nil else { return }
    }
}

//MARK: Metodos UITableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = artistTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        celda.textLabel?.text = artist[indexPath.row].title
        return celda
    }
    
    // Envio de datos por el Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "segueDetailsArtist", let destination = segue.destination as? DetailArtistViewController, let artistIndex = artistTableView.indexPathForSelectedRow?.row {
            destination.id = artist[artistIndex].id ?? 1
            destination.name = artist[artistIndex].title ?? "N/A"
            destination.cover_image = artist[artistIndex].cover_image ?? "https://i.pinimg.com/564x/af/96/fb/af96fb76ec66e466193f266e32732f7b.jpg"
            destination.resource_url = artist[artistIndex].resource_url ?? "N/A"
//            destination.profile = detailArtist[0].profile!
        }
    }
}
