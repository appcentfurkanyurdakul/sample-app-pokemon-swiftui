//
//  DetailContentView.swift
//  pokemon-swiftui
//
//  Created by Furkan Yurdakul on 1.07.2024.
//

import SwiftUI
import Kingfisher

struct DetailContentView: View {
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.apiResult {
            case .success(_):
                DetailTextsView(viewModel: viewModel)
            case .loading:
                ProgressView().frame(alignment: .center)
            default:
                EmptyView()
            }
        }
        .navigationTitle(viewModel.pokemonName)
    }
}

struct DetailTextsView: View {
    @ObservedObject var viewModel: DetailViewModel
    
    var body: some View {
        if let item = viewModel.detailUiItem {
            VStack {
                ScrollView(.vertical) {
                    HStack {
                        if let frontImage = item.frontImage {
                            KFImage(URL(string: frontImage))
                        }
                        if let backImage = item.backImage {
                            KFImage(URL(string: backImage))
                        }
                    }
                    LazyVStack {
                        ForEach(item.texts, id: \.self) { text in
                            switch text.textType {
                            case .bigHeader:
                                Text(text.text)
                                    .font(.system(size: 16, weight: .bold))
                                    .padding([.top, .bottom], 12)
                            case .header:
                                Text(text.text)
                                    .font(.system(size: 16, weight: .bold))
                                    .padding([.top, .bottom], 6)
                            case .label:
                                Text(text.text)
                                    .font(.system(size: 12, weight: .medium))
                                    .padding([.top, .bottom], 3)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    DetailContentView(viewModel: DetailViewModel(pokemonName: "Bulbasaur", pokemonDetailUrl: "https://example.com"))
}
