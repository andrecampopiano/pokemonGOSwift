//
//  PokemonAnnotation.swift
//  PokemonGo
//
//  Created by André Luís  Campopiano on 27/02/17.
//  Copyright © 2017 André Luís  Campopiano. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnnotation:NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var pokemon:Pokemon
    
    init(coordinates: CLLocationCoordinate2D, pokemon: Pokemon) {
        self.coordinate = coordinates
        self.pokemon = pokemon
    }
    
    
}
