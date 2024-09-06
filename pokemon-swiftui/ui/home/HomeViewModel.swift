//
//  HomeViewModel.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 24.06.2024.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published
    private(set) var areItemsLoading = false
    
    @Published
    private(set) var items: [PokemonHomePageItem] = []
    
    private let limit = 50
    private var isRequesting = false
    private var currentOffset = 0
    private var reachedToTheEnd = false
    
    init() {
        requestMore()
    }
    
    func requestMore() {
        if isRequesting || reachedToTheEnd {
            return
        }
        isRequesting = true
        Task {
            await MainActor.run {
                areItemsLoading = true
            }
            let result: ApiResult<PokemonHomePageResponse> = await ApiManager.shared.makeRequest(
                endpoint: "pokemon",
                method: .GET,
                requestModel: PokemonHomePageRequest(
                    limit: limit,
                    offset: currentOffset
                )
            )
            await result.onSuccess { [weak self] data in
                guard let self = self else { return }
                let mappedItems = data.results.map { item in
                    PokemonHomePageItem(name: item.name.capitalizingFirstLetter(), url: item.url)
                }
                await MainActor.run {
                    self.items.append(contentsOf: mappedItems)
                }
                self.currentOffset += data.results.count
                if self.currentOffset >= data.count {
                    reachedToTheEnd = true
                }
            }
            await MainActor.run {
                areItemsLoading = false
            }
            isRequesting = false
            print("Request finished")
        }
    }
}
