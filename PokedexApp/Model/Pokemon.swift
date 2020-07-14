//
//  Pokemon.swift
//  PokedexApp
//
//  Created by Christopher Adolphe on 09/02/2018.
//  Copyright © 2018 Christopher Adolphe. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    // Create Pokemon properties
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionID: String!
    private var _nextEvolutionName: String!
    private var _pokemonURL: String!
    private var _characteristicsURL: String!
    private var _evolutionURL: String!
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        
        return _attack
    }
    
    var nextEvolutionID: String {
        if _nextEvolutionID == nil {
            _nextEvolutionID = ""
        }
        
        return _nextEvolutionID
    }
    
    var nextEvolutionName: String {
        if _nextEvolutionName == nil {
            _nextEvolutionName = ""
        }
        
        return _nextEvolutionName
    }
    
    // Create getters
    var name: String {
        return _name
    }
    
    var pokedexID: Int {
        return _pokedexID
    }
    
    // Create initializer for Pokemon object
    init(name: String, pokedexID: Int) {
        self._name = name
        self._pokedexID = pokedexID
        self._pokemonURL = "\(END_POINT)\(POKEMON_PATH)\(self._pokedexID!)/"
        self._characteristicsURL = "\(END_POINT)\(CHARACTERISTICS_PATH)\(self._pokedexID!)/"
        self._evolutionURL = "\(END_POINT)\(EVOLUTION_PATH)\(self._pokedexID!)/"
    }
    
    //  Method to download data from API when a pokemon is selected on the main view
    func downloadPokemonDetail(completed: @escaping DownloadComplete) {
        // Create Alamofire GET request
        Alamofire.request(_pokemonURL).responseJSON { response in
            // Create a dictionary to store the data from the response
            if let data = response.result.value as? Dictionary<String, AnyObject> {
                // Getting types data
                if let types = data["types"] as? [Dictionary<String, AnyObject>], types.count > 0 {
                    // If pokemon has only one type
                    if let type = types[0]["type"] as? Dictionary<String, String> {
                        if let name = type["name"] {
                            self._type = name.capitalized
                        }
                    }
                    
                    // If pokemon has more than one type, then loop through the different types
                    if types.count > 1 {
                        for i in 1..<types.count {
                            if let type = types[i]["type"] as? Dictionary<String, String> {
                                if let name = type["name"] {
                                    self._type! += "/\(name.capitalized)"
                                }
                            }
                        }
                    }
                }
                else {
                    self._type = ""
                }
                
                // Getting defense and attack data
                if let stats = data["stats"] as? [Dictionary<String, AnyObject>] {
                    if let defense_stat = stats[3]["base_stat"] as? Int {
                        self._defense = "\(defense_stat)"
                    }
                    
                    if let attack_stat = stats[4]["base_stat"] as? Int {
                        self._attack = "\(attack_stat)"
                    }
                }
                
                // Getting height data
                if let height = data["height"] as? Int {
                    self._height = "\(height)"
                }
                
                // Getting weight data
                if let weight = data["weight"] as? Int {
                    self._weight = "\(weight)"
                }
            }
            
            completed()
        }
        
        // Create Alamofire GET request for pokemon description
        Alamofire.request(_characteristicsURL).responseJSON { response in
            if let data = response.result.value as? Dictionary<String, AnyObject> {
                if let descriptions = data["descriptions"] as? [Dictionary<String, AnyObject>], descriptions.count > 0 {
                    if let description = descriptions[1]["description"] {
                        self._description = "\(description)"
                    }
                }
                else {
                    self._description = ""
                }
            }
            
            completed()
        }
        
        // Create Alamofire GET requestion for pokemon evolution
        Alamofire.request(_evolutionURL).responseJSON { response in
            if let data = response.result.value as? Dictionary<String, AnyObject> {
                if let chain = data["chain"] as? Dictionary<String, AnyObject> {
                    if let evolvesTo = chain["evolves_to"] as? [Dictionary<String, AnyObject>] {
                        if let species = evolvesTo[0]["species"] as? Dictionary<String, String> {
                            if let url = species["url"] {
                                let newStr = url.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                let nextEvoID = newStr.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionID = nextEvoID
                            }
                            
                            if let name = species["name"] {
                                self._nextEvolutionName = name
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
}
