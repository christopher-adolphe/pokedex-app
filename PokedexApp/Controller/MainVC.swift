//
//  MainVC.swift
//  PokedexApp
//
//  Created by Christopher Adolphe on 09/02/2018.
//  Copyright © 2018 Christopher Adolphe. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Create and initialize an empty array of type Pokemon to store pokemon data
    var pokemons = [Pokemon]()
    
    // Create and initialize an empty array of type Pokemon to store filtered pokemon data
    var filteredPokemons = [Pokemon]()
    
    // Create a boolean variable to check if user is making a search
    var inSearchMode = false
    
    // Create a audio player variable
    var bgMusic: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign delegate and datasource to self
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        // Change label of search button of onscreen keyboard to donw
        searchBar.returnKeyType = UIReturnKeyType.done
        
        // Parse csv to get pokemon info
        parsePokemonCSV()
        
        // Play background music
        initAudio()
    }
    
    // Method to initialize audio file
    func initAudio() {
        let audioPath = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do {
            // Try to assign the audio file from the specified path
            try bgMusic = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
            
            // Prepare audio file to be played
            bgMusic.prepareToPlay()
            
            // Set audio file to loop indefinitely
            bgMusic.numberOfLoops = -1
            
            // Play the audio file
            bgMusic.play()
        }
        catch let err as NSError {
            // If audio player fails, print the error description
            print(err.debugDescription)
        }
    }
    
    // Method to parse CSV data
    func parsePokemonCSV() {
        // Get the path to CSV file by accessing the project's directory through Bundle.main.path
        let csvPath = Bundle.main.path(forResource: "pokemon", ofType: "csv")!

        // Make the parsing using a do catch block
        do {
            // Instantiate a csv object from the CSV parser with the path of the csv file
            let csv = try CSV(contentsOfURL: csvPath)
            
            // Get rows in pokemon.csv
            let rows = csv.rows
            
            // csv.rows returns a dictionary, so we can loop through the constant 'rows' to retreive the key-value pairs
            for row in rows {
                // Retrieve the pokemon ID and name
                let pokeID = Int(row["id"]!)!
                let identifier = row["identifier"]!
                
                // Create a new pokemon object and supply the id and identifier obtained from the csv file
                let newPokemon = Pokemon(name: identifier, pokedexID: pokeID)
                
                // Append each newPokemon to the pokemons array
                pokemons.append(newPokemon)
            }
        }
        catch let err as NSError {
            // If parsing fails, print the error description
            print(err.debugDescription)
        }
    }
    
    // Method to manage creation of reusable cells in the collectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Create reusable cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            // Create a contant to store each pokemon to add to the cell
            let myPokemon: Pokemon!

            // Configure the cell with the pokemon object as parameter
            if inSearchMode {
                // Use filteredPokemons array if user is making a search
                myPokemon = filteredPokemons[indexPath.row]
                cell.configureCell(pokemon: myPokemon)
            }
            else {
                // Elsee use pokemons array to display all pokemons
                myPokemon = pokemons[indexPath.row]
                cell.configureCell(pokemon: myPokemon)
            }
            
            return cell
        }
        else {
            // Else return an empty generic cell
            return UICollectionViewCell()
        }
    }
    
    // Method to manage selected cell in the collectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon: Pokemon!
        
        if inSearchMode {
            selectedPokemon = filteredPokemons[indexPath.row]
        }
        else {
            selectedPokemon = pokemons[indexPath.row]
        }
        
        // Initiate the segue from the MainVC to the PokemonDetailVC passing the selectedPokemon
        performSegue(withIdentifier: "PokemonDetailVC", sender: selectedPokemon)
    }
    
    // Method to manage number of items in the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            // Count the number of elements for the filteredPokemons array when user is making a search
            return  filteredPokemons.count
        }
        
        // Count the number of elements for the pokemons array and return this exact amount of cell item
        return  pokemons.count
    }
    
    // Method to manage number of sections in the collectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Method to manage size of cells in the collectionView
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    // Method to manage search filter when typing in searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Change text color of searchField
        let searchBarText = searchBar.value(forKeyPath: "searchField") as?  UITextField
        searchBarText?.textColor = UIColor.gray
        
        // Check is search bar is nil or contains an empty string (user has delete the search term)
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            
            // Reload the collectionView with all pokemons
            collection.reloadData()
            
            // Hide onscreen keyboard after search term is erased
            view.endEditing(true)
        }
        else {
            // Else search term is valid so we set inSearchMode to true
            inSearchMode = true
            
            // Create a constant to store the search term from the search bar and turn it to lowercase
            let searchTerm = searchBar.text!.lowercased()
            
            // Filter the name property in pokemons array over the searchTerm and assign the results to the filteredPokemons array
            // $0 is a placeholder for each element of the pokemons array
            filteredPokemons = pokemons.filter({$0.name.range(of: searchTerm) != nil })
            
            // Reload the collectionView with filtered pokemons
            collection.reloadData()
        }
    }
    
    // Method to hide onscreen keyboard when user presses on Search key
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // Method to pass data from the MainVC to PokemonDetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailVC = segue.destination as? PokemonDetailVC {
                // Sender is of type Pokemon
                if let selectedPokemon = sender as? Pokemon {
                    detailVC.pokemon = selectedPokemon
                }
            }
        }
    }
    
    // Method to pause/play background music
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if bgMusic.isPlaying {
            bgMusic.pause()
            
            // Fade the musicBtn when set to pause
            sender.alpha = 0.4
        }
        else {
            bgMusic.play()
            
            // Reset opacity of musicBtn when set to play
            sender.alpha = 1.0
        }
    }
}
