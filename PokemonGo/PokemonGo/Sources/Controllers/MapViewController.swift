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
    var coreDataPokemon:CoreDataPokemon!
    var pokemons: [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        managerLocation.delegate = self
        
        //Solicitar localização
        managerLocation.requestWhenInUseAuthorization()
        managerLocation.startUpdatingLocation()
        
        //recuperar pokemons
        self.coreDataPokemon = CoreDataPokemon()
        self.pokemons = self.coreDataPokemon.recoveryAllPokemons()
        
        
        
        //Exibir pokemons
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            if let coordinate = self.managerLocation.location?.coordinate{
                
                let totalPokemons = UInt32(self.pokemons.count)
                let indexPokemonRandow = arc4random_uniform(totalPokemons)
                let pokemon = self.pokemons[Int(indexPokemonRandow)]
                
                let annotation = PokemonAnnotation(coordinates: coordinate, pokemon:pokemon)
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
             let anot = (annotation as! PokemonAnnotation)
            annotationView.image = UIImage(named: anot.pokemon.nomeImagem!)
        }
        
        var frame = annotationView.frame
        frame.size.height = 40
        frame.size.width = 40
        annotationView.frame = frame
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        let pokemon = (view.annotation as! PokemonAnnotation).pokemon
        
        mapView.deselectAnnotation(annotation, animated: true)
        
        if annotation is MKUserLocation {
            return
        }
        if let coordAnnotation = annotation?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(coordAnnotation, 200, 200)
            mapView.setRegion(region, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.managerLocation.location?.coordinate {
                if MKMapRectContainsPoint(self.mapView.visibleMapRect, MKMapPointForCoordinate(coord)) {
                    
                    self.mapView.removeAnnotation(annotation!)
                    let alertController = UIAlertController(title: "É isso ai", message: "Você capturou o pokemon \(pokemon.nome!)", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                    alertController.addAction(actionOk)
                    
                    self.present(alertController, animated: true, completion: nil)
                    self.coreDataPokemon.savePokemon(pokemon: pokemon)
                }else {
                    let alertController = UIAlertController(title: "Você não pode Capturar", message: "Você precisa se aproximar mais para capturar o pokemon \(pokemon.nome!)", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    
                    alertController.addAction(actionOk)
                    
                    self.present(alertController, animated: true, completion: nil)
                    print("voce nao pode")
                }
            }

        }
        

        
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

