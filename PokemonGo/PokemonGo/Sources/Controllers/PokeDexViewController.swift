//
//  PokeDexViewController.swift
//  PokemonGo
//
//  Created by André Luís  Campopiano on 27/02/17.
//  Copyright © 2017 André Luís  Campopiano. All rights reserved.
//

import UIKit

class PokeDexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var pokemonsCaptured:[Pokemon] = []
    var pokemonsNotCaptured:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let coreData = CoreDataPokemon()
        self.pokemonsCaptured = coreData.recoveryPokemonCaptured(captured: true)
        self.pokemonsNotCaptured = coreData.recoveryPokemonCaptured(captured: false)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberRows:Int = 1
        
        if section == 0 {
            numberRows = pokemonsCaptured.count
        }
        if section == 1 {
            numberRows = pokemonsNotCaptured.count
        }
        
        return numberRows
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleSection:String!
        
        if section == 0 {
            titleSection = "Capturados"
        }
        if section == 1 {
            titleSection = "Não Capturados"
        }
        return titleSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
            cell.textLabel?.text = self.pokemonsCaptured[indexPath.row].nome
            cell.imageView?.image = UIImage(named: self.pokemonsCaptured[indexPath.row].nomeImagem!)
        }
        if indexPath.section == 1 {
            cell.textLabel?.text = self.pokemonsNotCaptured[indexPath.row].nome
            cell.imageView?.image = UIImage(named:self.pokemonsNotCaptured[indexPath.row].nomeImagem!)
        }
        return cell
    }
    
    @IBAction func backMap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
