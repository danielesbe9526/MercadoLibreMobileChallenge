//
//  ScreenFabric.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

/// `ScreenFabric` es una estructura que genera vistas basadas en un destino de pantalla específico.
struct ScreenFabric {
    
    /// ViewModel observado para la vista principal.
    @ObservedObject var homeViewModel: HomeViewModel
    
    /// Inicializador para `ScreenFabric`.
    /// - Parameter homeViewModel: ViewModel para la vista principal.
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    /// Crea una vista basada en el destino de pantalla proporcionado.
    /// - Parameter item: El destino de la pantalla que se usará para determinar qué vista crear.
    /// - Returns: Una vista correspondiente al destino de pantalla.
    @ViewBuilder
    func createView(item: ScreenDestination) -> some View {
        switch item {
        case .homeView:
            HomeView(viewModel: homeViewModel)
        case .productDetailView:
            ProductDetailView(viewModel: homeViewModel)
        case .developerView:
            DeveloperView(viewModel: homeViewModel)
        }
    }
}
