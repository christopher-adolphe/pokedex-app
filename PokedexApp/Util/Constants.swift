//
//  Constants.swift
//  PokedexApp
//
//  Created by Christopher Adolphe on 17/02/2018.
//  Copyright © 2018 Christopher Adolphe. All rights reserved.
//

import Foundation

let END_POINT = "https://pokeapi.co/"
let POKEMON_PATH = "api/v2/pokemon/"
let CHARACTERISTICS_PATH = "api/v2/characteristic/"
let EVOLUTION_PATH = "api/v2/evolution-chain/"

// Create a closure to let the view controller know when data has finish download from the API
typealias DownloadComplete = () -> ()
