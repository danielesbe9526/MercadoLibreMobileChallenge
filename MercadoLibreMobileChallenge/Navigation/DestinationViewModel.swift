//
//  DestinationViewModel.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation

/// `DestinationViewModel` es una clase que gestiona la navegación entre diferentes destinos de pantalla.
final public class DestinationViewModel: ObservableObject {
    
    /// Lista de destinos de pantalla.
    @MainActor
    @Published public var destination: [ScreenDestination]
    
    /// Indica si la navegación está vacía.
    @MainActor
    public var isNavigationEmpty: Bool {
        destination.isEmpty
    }
    
    /// Inicializador para `DestinationViewModel`.
    /// - Parameter destination: Lista inicial de destinos de pantalla, vacía por defecto.
    @MainActor
    public init(destination: [ScreenDestination] = []) {
        self.destination = destination
    }
    
    /// Navega a un destino específico, asegurando que no haya duplicados.
    /// - Parameter destination: El destino al que se desea navegar.
    @MainActor
    public func navigate(to destination: ScreenDestination) {
        self.destination.removeAll(where: { $0 == destination })
        self.destination.append(destination)
    }
    
    /// Navega hacia atrás en la pila de navegación.
    /// - Parameter last: Número de pantallas a retroceder, -1 por defecto.
    @MainActor
    public func navigateBack(to last: Int = -1) {
        guard destination.count >= last else {
            return
        }
        destination.removeLast()
    }
    
    /// Navega de vuelta a una pantalla específica.
    /// - Parameter screen: El destino de pantalla al que se desea volver.
    @MainActor
    public func popToScreen(_ screen: ScreenDestination) {
        guard let screenIndex = destination.firstIndex(where: { $0 == screen }) else {
            return
        }
        destination = Array(destination.prefix(through: screenIndex))
    }
}
