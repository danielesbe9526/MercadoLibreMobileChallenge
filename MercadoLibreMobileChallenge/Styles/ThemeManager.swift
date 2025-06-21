//
//  ThemeManager.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 19/06/25.
//

import Foundation
import SwiftUI

/// `ThemeManager` es una clase que gestiona los temas de color para una aplicación.
class ThemeManager: ObservableObject {
    
    /// Color primario del tema.
    @Published var primaryColor: Color = .azulML
    
    /// Color de la fuente.
    @Published var fontColot: Color = .font
    
    /// Color para acciones destacadas.
    @Published var callToActionColor: Color = .verdeML
    
    /// Color principal.
    @Published var mainColor: Color = .amarilloML
    
    /// Color de fondo.
    @Published var backgroundColor: Color = .white
    
    /// Color del texto.
    @Published var textColor: Color = .black
    
    /// Cambia el color primario a un color dado.
    /// - Parameter color: Nuevo color primario.
    func changeColor(_ color: Color) {
        self.primaryColor = color
    }
    
    /// Cambia el tema al tema especificado.
    /// - Parameter theme: El nuevo tema a aplicar.
    func changeTeme(theme: ColorTheme) {
        switch theme {
        case .light:
            self.primaryColor = .azulML
            self.fontColot = .font
            self.callToActionColor = .verdeML
            self.mainColor = .amarilloML
            self.backgroundColor = .white
            self.textColor = .black
        case .dark:
            self.primaryColor = .azulML
            self.fontColot = .white.opacity(0.7)
            self.callToActionColor = .green
            self.mainColor = .amarilloML
            self.backgroundColor = .black
            self.textColor = .white
        case .developer:
            self.primaryColor = .indigo
            self.fontColot = .verdeML
            self.callToActionColor = .green
            self.mainColor = .green.opacity(0.7)
            self.backgroundColor = .black
            self.textColor = .green
        case .custom:
            break
        }
    }
    
    /// Cambia a un tema personalizado utilizando una paleta de colores.
    /// - Parameter palette: La paleta de colores a aplicar.
    func changeCustomTheme(palette: ColorPalette) {
        self.primaryColor = palette.primaryColor
        self.fontColot = palette.fontColot
        self.callToActionColor = palette.callToActionColor
        self.mainColor = palette.mainColor
        self.backgroundColor = palette.backgroundColor
        self.textColor = palette.textColor
    }
}

/// `ColorTheme` es un enum que define los temas de color disponibles.
enum ColorTheme: Identifiable, Hashable {
    case light
    case dark
    case developer
    case custom
    
    /// Identificador del tema.
    var id: String {
        switch self {
        case .light:
            return "light"
        case .dark:
            return "dark"
        case .developer:
            return "developer"
        case .custom:
            return "custom"
        }
    }

    /// Nombre del tema.
    var name: String {
        switch self {
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        case .developer:
            return "Developer"
        case .custom:
            return "Custom"
        }
    }

    /// Todos los casos del enum.
    static var allCases: [ColorTheme] {
        return [.light, .dark, .developer, .custom]
    }
}

/// `ColorPalette` es una estructura que representa una paleta de colores personalizada.
struct ColorPalette: Hashable {
    var primaryColor: Color
    var fontColot: Color
    var callToActionColor: Color
    var mainColor: Color
    var backgroundColor: Color
    var textColor: Color
}
