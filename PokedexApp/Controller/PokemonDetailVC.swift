//
//  PokemonDetailVC.swift
//  PokedexApp
//
//  Created by Christopher Adolphe on 11/02/2018.
//  Copyright © 2018 Christopher Adolphe. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evolutionLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name.capitalized
        pokedexLbl.text = "\(pokemon.pokedexID)"
        mainImg.image = UIImage(named: "\(pokemon.pokedexID)")
        currentEvoImg.image = UIImage(named: "\(pokemon.pokedexID)")
        
        pokemon.downloadPokemonDetail {
            // Update UI after network call is complete
            self.updateUI()
        }
    }
    
    // Method to update UI
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        attackLbl.text = pokemon.attack
        evolutionLbl.text = "Next evolution: " + pokemon.nextEvolutionName
        nextEvoImg.image = UIImage(named: pokemon.nextEvolutionID)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        // Diss the actual viewController
        dismiss(animated: true, completion: nil)
    }
}
