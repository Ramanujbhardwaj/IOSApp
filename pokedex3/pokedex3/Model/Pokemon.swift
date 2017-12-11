//
//  Pokemon.swift
//  pokedex3
//
//  Created by Ramanuj Bhardwaj on 12/4/17.
//  Copyright © 2017 Ramanuj Bhardwaj. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon{
    
    private var _name: String!
    
    private var _pokedexId: Int!
    
    private var _description: String!
    
    private var _type: String!
    
    private var _defense: String!
    
    private var _height: String!
    
    private var _weight: String!
    
    private var _attack: String!
    
    private var _nextEvolutionText: String!
    
    private var _nextEvolutionName: String!
    
    private var _nextEvolutionId: String!
    
    private var _nextEvolutionLevel: String!
    
    private var _pokemonURL: String!
    
    private var _pokemonDescURL: String!
    
    private var _pokemonEvolutionURL: String!
    
    
    
    var description: String{
        if _description == nil{
            _description = ""
        }
        return _description
    }
    
    var type: String{
        if _type == nil{
            _type = ""
        }
        return _type
    }
    
    var defense: String{
        if _defense == nil{
            _defense = ""
        }
        return _defense
    }
    
    var height: String{
        if _height == nil{
            _height = ""
        }
        return _height
    }
    
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    
    var nextEvolutionName: String{
        if _nextEvolutionName == nil{
            _nextEvolutionName = ""
        }
        return _nextEvolutionName
    }
    
    var nextEvolutionId: String{
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel: String{
        if _nextEvolutionLevel == nil{
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    var nextEvolutionText: String{
        if _nextEvolutionText == nil{
            _nextEvolutionText = ""
        }
        return _nextEvolutionText
    }
    
    var name: String{
        
        return _name
        
    }
    
    var pokedexId: Int{
        
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int){
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)/"
        self._pokemonDescURL = "\(URL_BASE)\(URL_DESCRIPTION)\(self.pokedexId)/"
        self._pokemonEvolutionURL = "\(URL_BASE)\(URL_EVOLUTION)\(self.pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete){
        Alamofire.request(_pokemonURL).responseJSON { response in
            
            
            if let dict = response.value as? Dictionary<String, AnyObject>{
                self._weight = "\(dict["weight"]!)"
                self._height = "\(dict["height"]!)"
                self._name = "\(dict["name"]!)"
                self._pokedexId = dict["id"] as? Int
                
                // Fetching the attack and defense value
                guard let statsNode = dict["stats"] as? [[String: Any]] else { return }
                
                for (index, statNode) in statsNode.enumerated() {
                    
                    guard let statValue = statNode["base_stat"] as? Int else { continue }
                    
                    switch index {
                    case 0:
                        self._defense = "\(statValue)"
                    case 1:
                        self._attack = "\(statValue)"
                    default:
                        break
                    }
                    
                }
                // End of attack and defense value.
                
                //Fetching the types value.
                    //Below we are putting a semicolon which is the where clause to say there should be atleast 1 value to go inside the loop.
                if let types = dict["types"] as? [Dictionary<String, AnyObject>],  types.count > 0{
                    
                    if let type = types[0]["type"] as? Dictionary<String, String>{
                        if let name = type["name"]{
                            self._type = name.capitalized
                        }
                    }
                    //More than one type than below logic is required.
                    if types.count > 1{ // If count is more than 1.
                        for x in 1..<types.count{
                            if let type = types[x]["type"] as? Dictionary<String, String>{
                                if let name = type["name"]{
                                    self._type! += "/\(name.capitalized)" //Adding the type to the existing variable.
                                }
                            }
                        }
                    }
                    
                }else{
                    self._type = ""
                }
                print(self._type)
                //End of types value.
            }
            //Start of description reading
            Alamofire.request(self._pokemonDescURL).responseJSON(completionHandler: { (response) in
                if let dict = response.value as? Dictionary<String, AnyObject>{
                    
                    if let flavor_text_entries = dict["flavor_text_entries"] as? [Dictionary<String, AnyObject>], flavor_text_entries.count > 0{
                        self._description = String(describing: flavor_text_entries[1]["flavor_text"]!)
                    }else{
                        self._description = ""
                    }
                }
                completed()
            })
            
            //Start of Evolution reading
            Alamofire.request(self._pokemonEvolutionURL).responseJSON(completionHandler: { (response) in
                if let dict = response.value as? Dictionary<String, AnyObject>{
                    if let chain = dict["chain"] as? Dictionary<String, AnyObject>{
                        if let evolves_to = chain["evolves_to"] as? [Dictionary<String, AnyObject>], evolves_to.count>0{
                            if let species = evolves_to[0]["species"] as? Dictionary<String,String>{
                                self._nextEvolutionName =  species["name"]?.capitalized
                                let newURI = species["url"]?.replacingOccurrences(of: "https://pokeapi.co/api/v2/pokemon-species/", with: "")
                                let nextEvoURL = newURI?.replacingOccurrences(of: "/", with: "")
                                self._nextEvolutionId = nextEvoURL
                            }
                            
                        }else{
                            self._nextEvolutionName =  ""
                            self._nextEvolutionId = ""
                        }
                    }
                    
                }
                completed()
            })
            
            completed()
        }
        
        
    }
    
    
    
    
}
