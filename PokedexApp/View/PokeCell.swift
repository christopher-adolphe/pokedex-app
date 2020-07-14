//
//  PokeCell.swift
//  PokedexApp
//
//  Created by Christopher Adolphe on 10/02/2018.
//  Copyright © 2018 Christopher Adolphe. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    // Create an instance variable of Pokemon class
    var newPokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    // Create a method to update content of collectionView cell which takes a parameter a Pokemon object
    func configureCell(pokemon: Pokemon) {
        // Initialize the newPokemon so as we can access the different properties of it's class
        self.newPokemon = pokemon
        
        // Update the UI elements with newPokemon properties
        thumbImg.image = UIImage(named: "\(self.newPokemon.pokedexID)")
        nameLbl.text = self.newPokemon.name
    }
}
