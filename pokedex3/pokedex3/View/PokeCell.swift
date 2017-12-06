//
//  PokeCell.swift
//  pokedex3
//
//  Created by Ramanuj Bhardwaj on 12/5/17.
//  Copyright © 2017 Ramanuj Bhardwaj. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(pokemon: Pokemon){
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
        
    }
    
    //This is written to round off the images of pokemon.
    //This is a universal function which will round off all images in the CollectionViewTable.
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
}
