//
//  NavigationWrapperView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

/// `NavigationWrapperView` es una vista que envuelve contenido en un `NavigationStack` y maneja la navegación.
struct NavigationWrapperView<Content: View>: View {
    /// Objeto que maneja el tema de color de la aplicación.
    @EnvironmentObject var colorManager: ThemeManager
    
    /// ViewModel que gestiona la navegación de destinos.
    @ObservedObject var destination: DestinationViewModel
    
    /// `ScreenFabric` que crea vistas basadas en destinos de pantalla.
    var fabric: ScreenFabric
    
    /// Contenido de la vista envuelta.
    var content: () -> Content
    
    /// Inicializador para `NavigationWrapperView`.
    /// - Parameters:
    ///   - destination: ViewModel para manejar la navegación.
    ///   - fabric: Objeto que genera vistas para diferentes destinos.
    ///   - content: Contenido a ser mostrado dentro del `NavigationStack`.
    init(destination: DestinationViewModel, fabric: ScreenFabric, @ViewBuilder content: @escaping () -> Content) {
        self.destination = destination
        self.fabric = fabric
        self.content = content
    }
    
    /// El cuerpo de la vista, que incluye un `NavigationStack`.
    var body: some View {
        NavigationStack(path: $destination.destination) {
            content()
                .navigationDestination(for: ScreenDestination.self) {
                    fabric.createView(item: $0)
                }
                .background(
                    Color(colorManager.mainColor)
                        .ignoresSafeArea(edges: .top)
                )
        }
    }
}
