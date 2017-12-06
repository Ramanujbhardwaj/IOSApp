//
//  PokemonDetailVC.swift
//  pokedex3
//
//  Created by Ramanuj Bhardwaj on 12/5/17.
//  Copyright © 2017 Ramanuj Bhardwaj. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLbl.text = pokemon.name
        // Do any additional setup after loading the view.
    }

   

  

}
