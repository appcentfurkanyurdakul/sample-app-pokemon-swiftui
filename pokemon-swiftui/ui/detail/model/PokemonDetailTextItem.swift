//
//  DetailUiItem.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 26.06.2024.
//

import Foundation

struct PokemonDetailTextItem : Identifiable, Hashable {
    let textType: PokemonDetailTextItemType
    let text: String
    
    var id: String {
        return text
    }
}
