//
//  MapViewController.swift
//  PokemonGo
//
//  Created by André Luís  Campopiano on 27/02/17.
//  Copyright © 2017 André Luís  Campopiano. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var managerLocation = CLLocationManager()
    var contador:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        managerLocation.delegate = self
        
        //Solicitar localização
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()
        
        //Exibir pokemons
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            print("teste")
            if let coordinate = self.managerLocation.location?.coordinate{
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.coordinate.latitude += (Double(arc4random_uniform(400)) - 200) / 100000.0
                annotation.coordinate.longitude += (Double(arc4random_uniform(400)) - 200) / 100000.0
                self.mapView.addAnnotation(annotation)
            }
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        
        
        
        if annotation is MKUserLocation {
            annotationView.image = #imageLiteral(resourceName: "player")
        }else{
            annotationView.image = #imageLiteral(resourceName: "pikachu-2")
        }
        
        var frame = annotationView.frame
        frame.size.height = 40
        frame.size.width = 40
        annotationView.frame = frame
        return annotationView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contador < 4 {
            self.center()
            contador += 1
        }else {
            managerLocation.stopUpdatingLocation()
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            let alertController = UIAlertController(title: "Permissão de localização", message: "Necessário a sua localização para começar a caçar pokemons.", preferredStyle: .alert)
            
            let actionConfig = UIAlertAction(title: "Abrir Configurações", style: .default, handler: { (alertConfig) in
                if let config = NSURL(string: UIApplicationOpenSettingsURLString){
                    UIApplication.shared.open(config as URL)
                }
            })
            
            let actionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            alertController.addAction(actionConfig)
            alertController.addAction(actionCancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func center(){
        if let coordinate = managerLocation.location?.coordinate {
            
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200)
            
            mapView.setRegion(region, animated: true)
        }

    }
    
    @IBAction func centerPlayer(_ sender: Any) {
       self.center()
    }
    

    @IBAction func openPokedex(_ sender: Any) {
    }
}

