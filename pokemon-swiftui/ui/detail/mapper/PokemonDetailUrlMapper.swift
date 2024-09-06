//
//  PokemonDetailUrlMapper.swift
//  pokemon-swiftui
//
//  Created by Furkan Yurdakul on 6.09.2024.
//

import Foundation

class PokemonDetailUrlMapper {
    func getUrl(id: String) -> String {
        return "pokemon/\(id)"
    }
}
