//
//  ScreenDestination.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

/// `ScreenDestination` es un enum que representa los diferentes destinos de pantalla en la aplicación.
public enum ScreenDestination: Hashable, Sendable, Equatable {
    
    /// Pantalla de inicio.
    case homeView
    
    /// Pantalla de detalles del producto.
    case productDetailView
    
    /// Pantalla del desarrollador.
    case developerView
}
