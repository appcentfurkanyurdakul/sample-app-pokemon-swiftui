//
//  DetailViewModel.swift
//  pokemon-swiftui
//
//  Created by Furkan Yurdakul on 1.07.2024.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    let pokemonName: String
    
    @Published
    var detailUiItem: PokemonDetailUiItem? = nil
    
    @Published
    private(set) var apiResult: ApiResult<PokemonDetailUiItem> = .initial
    
    private let pokemonDetailUrl: String
    
    private let mapper = PokemonDetailPageResponseMapper()
    private let urlMapper = PokemonDetailUrlMapper()
    
    init(pokemonName: String, pokemonDetailUrl: String) {
        self.pokemonName = pokemonName
        self.pokemonDetailUrl = pokemonDetailUrl
        requestData()
    }
    
    func requestData() {
        Task {
            await MainActor.run {
                apiResult = .loading
            }
            let result: ApiResult<PokemonDetailPageResponse> = await ApiManager.shared.makeRequest(
                url: pokemonDetailUrl,
                method: .GET
            )
            let mappedResult = await result.mapSuccess { data in
                let mappedData = self.mapper.map(pokemonName: self.pokemonName, inValue: data)
                return mappedData
            }
            await mappedResult.onSuccess { [self] data in
                await MainActor.run {
                    detailUiItem = data
                }
            }
            await MainActor.run {
                apiResult = mappedResult
            }
        }
    }
}
