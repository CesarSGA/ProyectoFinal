//
//  StoreViewController.swift
//  Music
//
//

import UIKit
import MapKit

class StoreViewController: UIViewController {

    var manager = CLLocationManager()
    var latitud : CLLocationDegrees!
    var longitud : CLLocationDegrees!

    @IBOutlet weak var mapaKitView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        searchBar.delegate = self
    }
    
    @IBAction func locatonButton(_ sender: UIButton) {
        mapaKitView.removeAnnotations(mapaKitView.annotations)
        self.locationUser()
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Mixup"
        
        let localizacion = CLLocationCoordinate2DMake(self.latitud, self.longitud)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: localizacion, span: span)
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            for item in response!.mapItems {
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
            }
        })
    }
}

extension StoreViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.latitud = location.coordinate.latitude
            self.longitud = location.coordinate.longitude
        }
    }
}

extension StoreViewController: UISearchBarDelegate {
    // Funcion para buscar en la barra
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Ocultar la el teclado de la barra de busqueda
        searchBar.resignFirstResponder()
        // Remover los puntos
        mapaKitView.removeAnnotations(mapaKitView.annotations)
        search(search: self.searchBar.text ?? "")
    }
    
    func locationUser(){
        // Localicacion en el mapa
        let localizacion = CLLocationCoordinate2DMake(self.latitud, self.longitud)
        
        // Mostrar mas cerca o mas lejos al acercar a la ubicacion
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        // Region donde esta el usuario
        let region = MKCoordinateRegion(center: localizacion, span: span)
        
        self.mapaKitView.setRegion(region, animated: true)
        self.mapaKitView.showsUserLocation = true
    }
    
    func search(search: String) {
        let request = MKLocalSearch.Request()
        if search != "" {
            request.naturalLanguageQuery = search
        } else {
            request.naturalLanguageQuery = "Mixup"
        }
        
        let localizacion = CLLocationCoordinate2DMake(self.latitud, self.longitud)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        request.region = MKCoordinateRegion(center: localizacion, span: span)
        
        let search = MKLocalSearch(request: request)
        search.start(completionHandler: {(response, error) in
            for item in response!.mapItems {
                self.addPinToMapView(title: item.name, latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
            }
        })
    }
    
    func addPinToMapView(title: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = title
            self.mapaKitView.addAnnotation(annotation)
            self.mapaKitView.showsUserLocation = true
        }
    }
}
