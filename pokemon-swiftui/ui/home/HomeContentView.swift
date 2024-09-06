//
//  ContentView.swift
//  pokemon-swiftui
//
//  Created by Furkan Yurdakul on 27.06.2024.
//

import SwiftUI
import Combine

struct HomeContentView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State var isActive = false
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
            ScrollView(.vertical) {
                LazyVGrid(
                    columns: columns,
                    spacing: 5
                ) {
                    ForEach(0..<viewModel.items.count, id: \.self) { index in
                        PokemonCell(pokemon: viewModel.items[index])
                            .onAppear {
                                if index == viewModel.items.count - 1 {
                                    viewModel.requestMore()
                                }
                            }
                            .onTapGesture {
                                let item = viewModel.items[index]
                                path.append(
                                    PokemonDetail(
                                        pokemonName: item.name,
                                        pokemonDetailUrl: item.url
                                    )
                                )
                            }
                    }
                }
            }
            .clipped()
            if viewModel.areItemsLoading {
                ProgressView()
                    .frame(width: 20, height: 20, alignment: .bottom)
                    .tint(.black)
            } else {
                EmptyView()
                    .frame(width: 20, height: 20, alignment: .bottom)
            }
        }
        .navigationTitle("Pokemons")
        .navigationDestination(for: PokemonDetail.self) { detail in
            DetailContentView(
                viewModel: DetailViewModel(
                    pokemonName: detail.pokemonName,
                    pokemonDetailUrl: detail.pokemonDetailUrl
                )
            )
        }
    }
}

struct PokemonCell: View {
    let pokemon: PokemonHomePageItem
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(.green.opacity(0.3))
            Text(pokemon.name)
                .font(.system(size: 12))
                .padding()
        }
        .frame(minHeight: 100)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var path: NavigationPath
        
        var body: some View {
            HomeContentView(path: $path)
        }
    }
    return PreviewWrapper(path: NavigationPath())
}
