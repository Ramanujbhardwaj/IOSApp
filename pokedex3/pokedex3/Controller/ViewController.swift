//
//  ViewController.swift
//  pokedex3
//
//  Created by Ramanuj Bhardwaj on 12/4/17.
//  Copyright © 2017 Ramanuj Bhardwaj. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection:UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon = [Pokemon]()
    var filterPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
        initAudio()
    }
    
    //Function to play the music
    func initAudio(){
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.stop()
          
        }catch let error as NSError{
            print(error.debugDescription)
        }
    }
    func parsePokemonCSV(){
        //Below is the code to read file from the resources.
        //Please note, i have updated the BuildPhase (CopyBundleResource) tag with the file.
    
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows{
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        }catch let error as NSError{
            print(error.debugDescription)
        }
        
    }
    
    //This function will reuse the PokeCell to load as many required instead of all 718 pokecell.
    //We create this func in case we are using CollectionView in the UI.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //We are stating that if the cell can be reused to display collection than do it else create a new one.
       if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
        
        // the pokemon object is getting set in the ParsePokemonCSV function in the same file.
//        let poke = pokemon[indexPath.row]
        
        /*
         To make the searchBar functionality working we have commented the above line.
         */
        let poke: Pokemon!
        
        if inSearchMode{
            poke = filterPokemon[indexPath.row]
            cell.configureCell(pokemon: poke)
        }else{
            poke = pokemon[indexPath.row]
            cell.configureCell(pokemon: poke)
        }
        
        cell.configureCell(pokemon: poke) //This line will call the PokeCell function to set the name and id of pokemon.
            return cell
        }else{
            return UICollectionViewCell()
        
        }
    }
    //Below is the function called for Segway from ViewController to PokemonDetailVC
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode{
            poke = filterPokemon[indexPath.row]
        }else{
            poke = pokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode{
            return filterPokemon.count
        }
        return pokemon.count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    //This function define the size of the cell where pokemon images will be displayed.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 102, height: 101)
    }
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying{
            musicPlayer.pause()
            sender.alpha=0.2
        }else{
            musicPlayer.play()
            sender.alpha=0.1
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            collection.reloadData()
            
            // Below code it to make the keyboard disappear once we finish editing.
            view.endEditing(true)
            
        }else{
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            /*
             We are taking the pokemon list into filterPokemon, where $0 is the placeholder for each item
             in the array.
             i.e. each pokemons name value. Than we are seeing whether the $0.name value is in the searchbar inside
             that range. If this is true than only we are putting it in the filterPokemon.
             */
            filterPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            
            collection.reloadData()
        }
        
    }
    
    //This function is called before the Segue occur. This is the place where data is set to be passed between controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="PokemonDetailVC"{
            if let detailVC = segue.destination as? PokemonDetailVC{
                if let poke = sender as? Pokemon{
                    detailVC.pokemon = poke // destination view controller containing variable pokemon is been set as poke.
                }
            }
        }
    }
}

