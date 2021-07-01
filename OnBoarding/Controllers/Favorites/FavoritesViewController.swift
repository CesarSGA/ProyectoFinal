//
//  FavoritesViewController.swift
//  OnBoarding
//
//

import UIKit
import Firebase

class FavoritesViewController: UIViewController {
    
    var favorites = [Favorites]()
    var id: Int?
    var name: String?
    var type: String?
    
    // Agregar la referencia a la Base de Datos Firestore
    let db = Firestore.firestore()

    @IBOutlet weak var favoritesTablewView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.cargarFavoritos()
        // Recargamos la tabla
        DispatchQueue.main.async {
            self.favoritesTablewView.reloadData()
        }
    }
    
    func createSpinnerView(time: Double) {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    func cargarFavoritos() {
        let user = Auth.auth().currentUser
        if let user = user {
            let email = user.email
            db.collection(email!).order(by: "year", descending: true).addSnapshotListener() { (querySnapshot, err) in
                // Vaciar arreglo de chats
                self.favorites.removeAll()
                
                if let err = err {
                    print("Error al obtener los datos: \(err.localizedDescription)")
                } else {
                    if let snapshotDocumentos = querySnapshot?.documents {
                        for document in snapshotDocumentos {
                            // Crear mi objeto favorito
                            let datos = document.data()
                            
                            // Obtener los parametros para mi obj Favorito
                            let favouriteID = document.documentID
                            guard let id = datos["id"] as? Int else { return }
                            guard let name = datos["name"] as? String else { return }
                            guard let year = datos["year"] as? Int else { return }
                            guard let type = datos["type"] as? String else { return }
                            guard let artist = datos["artist"] as? String else { return }
                            
                            // Creamos el objeto
                            let nuevoFavorito = Favorites(id: id, favouriteID: favouriteID, name: name, year: year, type: type, artist: artist)
                            
                            // Añadimos el mensaje al arreglo
                            self.favorites.append(nuevoFavorito)
                            
                            // Recargamos la tabla
                            DispatchQueue.main.async {
                                self.favoritesTablewView.reloadData()
                            }
                            self.createSpinnerView(time: 0.5)
                        }
                    }
                }
            }
        }
    }
    
    func addFavourite(id: Int, favouriteID: String, name: String, year: Int, type: String, artist: String) {
        let newFavorite = Favorites(id: id, favouriteID: favouriteID, name: name, year: year, type: type, artist: artist)
        self.favorites.append(newFavorite)
        self.favoritesTablewView.reloadData()
    }
    
    func deleteFavourite(id: String) {
        let user = Auth.auth().currentUser
        if let user = user {
            let email = user.email
            db.collection(email!).document(String(id)).delete() { err in
                if let err = err {
                    print("Error: \(err.localizedDescription)")
                } else {
                    print("Dato eliminado")
                    // Recargamos la tabla
                    DispatchQueue.main.async {
                        self.favoritesTablewView.reloadData()
                    }
                }
            }
            self.cargarFavoritos()
        }
    }
}

// MARK: - Metodos para el TableView
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.favorites.count == 0 {
            self.createSpinnerView(time: 1.0)
            self.favoritesTablewView.setEmptyView(title: "No tienes Albums o Canciones.", message: "Tus Albumns y Canciones favoritas estaran aqui.")
        }
        else {
            self.favoritesTablewView.restore()
        }
        return self.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTablewView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.favorites[indexPath.row].name!
        cell.detailTextLabel?.text = favorites[indexPath.row].artist + " " + String(self.favorites[indexPath.row].year!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Recargamos la tabla
        DispatchQueue.main.async {
            self.favoritesTablewView.reloadData()
        }
        let delete = UIContextualAction(style: .destructive, title: "Eliminar") {  (contextualAction, view, boolValue) in self.deleteFavourite(id: self.favorites[indexPath.row].favouriteID!)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Obtener el valor de la celda para buscar los datos en CoreData
        let cell = sender as! UITableViewCell
        let indexPath = self.favoritesTablewView.indexPath(for: cell)
        id = favorites[indexPath!.row].id
        name = favorites[indexPath!.row].name
        type = favorites[indexPath!.row].type
        
        if segue.identifier == "favoriteDetail" {
            let objFavorite = segue.destination as! FavoriteDetailViewController
            objFavorite.id = id ?? 0
            objFavorite.name = name
            objFavorite.type = type ?? "N/A"
        }
    }
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
