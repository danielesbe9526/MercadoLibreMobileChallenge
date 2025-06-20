//
//  ScreenFabric.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

struct ScreenFabric {
    @ObservedObject var homeViewModel: HomeViewModel
    
    weak var session: APIInteractor?

    init(session: APIInteractor? = nil,
         homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.session = session
    }
    
    @ViewBuilder
    func createView(item: ScreenDestination) -> some View {
        switch item {
        case .homeView:
            HomeView(viewModel: homeViewModel)
        case .productDetailView:
            ProductDetailView(viewModel: homeViewModel)
        }
    }
}
