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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        managerLocation.delegate = self
        
        //Solicitar localização
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = managerLocation.location?.coordinate {
            
            let region = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200)
            
            mapView.setRegion(region, animated: true)
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

}

