//
//  CoreDataPokemon.swift
//  PokemonGo
//
//  Created by André Luís  Campopiano on 27/02/17.
//  Copyright © 2017 André Luís  Campopiano. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPokemon {
    // recuperar context
    func getManagerObjects()->NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managerObjects = appDelegate?.persistentContainer.viewContext
        
        return managerObjects!
    }
    
    
    //adicionar todos os pokemons
    func addAllPokemons(){
        
        let managerObjects = getManagerObjects()
        
        self.createPokemon(nome: "Mew", nomeImagem: "mew", capturado: false)
        self.createPokemon(nome: "Meowth", nomeImagem: "meowth", capturado: true)
        self.createPokemon(nome: "Abra", nomeImagem: "abra", capturado: false)
        self.createPokemon(nome: "Bellsprout", nomeImagem: "bellsprout", capturado: false)
        self.createPokemon(nome: "Bullbasaur", nomeImagem: "bullbasaur", capturado: false)
        self.createPokemon(nome: "Caterpie", nomeImagem: "caterpie", capturado: false)
        self.createPokemon(nome: "Charmander", nomeImagem: "charmander", capturado: false)
        self.createPokemon(nome: "Dratini", nomeImagem: "dratini", capturado: false)
        self.createPokemon(nome: "Eevee", nomeImagem: "eevee", capturado: false)
        self.createPokemon(nome: "Jigglypuff", nomeImagem: "jigglypuff", capturado: false)
        self.createPokemon(nome: "Mankey", nomeImagem: "mankey", capturado: false)
        self.createPokemon(nome: "Pidgey", nomeImagem: "pidgey", capturado: false)
        self.createPokemon(nome: "Pikachu", nomeImagem: "pikachu-2", capturado: false)
        self.createPokemon(nome: "Psyduck", nomeImagem: "psyduck", capturado: false)
        self.createPokemon(nome: "Rattata", nomeImagem: "rattata", capturado: false)
        self.createPokemon(nome: "Snorlax", nomeImagem: "snorlax", capturado: false)
        self.createPokemon(nome: "Squirtle", nomeImagem: "squirtle", capturado: false)
        self.createPokemon(nome: "Venonat", nomeImagem: "venonat", capturado: false)
        self.createPokemon(nome: "Weedle", nomeImagem: "weedle", capturado: false)
        self.createPokemon(nome: "Zubat", nomeImagem: "zubat", capturado: false)
        
        do {
            try managerObjects.save()
            print("Sucesso ao salvar")
        }catch let erro as NSError{
            print("Erro ao recuperar \(erro.description)")
        }
    }
    
    
    //criar os pokemons
    func createPokemon(nome:String, nomeImagem:String, capturado:Bool){
        let managerObjects = self.getManagerObjects()
        let pokemon = Pokemon(context: managerObjects)
        pokemon.nome = nome
        pokemon.nomeImagem = nomeImagem
        
    }
    
    func recoveryAllPokemons()->[Pokemon]{
        let managerObjects = getManagerObjects()
        
        do{
            let pokemons = try managerObjects.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            
            if pokemons.count == 0{
                self.addAllPokemons()
                return self.recoveryAllPokemons()
            }
            return pokemons
        }catch let erro as NSError{
            print("Erro ao recuperar \(erro.description)!")
        }
        return []
    }
}
