//
//  TextStyle.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation
import SwiftUI

/// `TextStyles` es un enum que define diferentes estilos de texto.
enum TextStyles {
    case store
    case brand
    case tittle
    case green12
    case discount
    case actionLabel
}

/// `TextStyle` es un modificador de vista que aplica estilos de texto basados en `TextStyles`.
struct TextStyle: ViewModifier {
    
    /// Estilo de texto a aplicar.
    var style: TextStyles
    
    /// Gestor de temas para obtener colores del tema actual.
    @EnvironmentObject var colorManager: ThemeManager

    /// Aplica el estilo de texto al contenido proporcionado.
    /// - Parameter content: Contenido al que se aplicará el estilo.
    /// - Returns: Vista modificada con el estilo de texto aplicado.
    func body(content: Content) -> some View {
        switch style {
        case .store:
            return content
                .font(.system(size: 12, weight: .thin))
                .foregroundColor(.white)
            
        case .brand:
            return content
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(colorManager.textColor)
            
        case .tittle:
            return content
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(colorManager.fontColot)
            
        case .green12:
            return content
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(colorManager.callToActionColor)
        
        case .discount:
            return content
                .font(.system(size: 12, weight: .light))
                .foregroundColor(colorManager.callToActionColor)
        
        case .actionLabel:
            return content
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(colorManager.primaryColor.opacity(0.5))
        }
    }
}

extension View {
    
    /// Aplica un estilo de texto a la vista.
    /// - Parameter style: El estilo de texto a aplicar.
    /// - Returns: Una vista con el estilo de texto aplicado.
    func textStyle(_ style: TextStyles) -> some View {
        self.modifier(TextStyle(style: style))
    }
}

extension View {
    
    /// Muestra un placeholder cuando se cumple una condición.
    /// - Parameters:
    ///   - shouldShow: Condición para mostrar el placeholder.
    ///   - alignment: Alineación del placeholder.
    ///   - placeholder: Vista del placeholder.
    /// - Returns: Una vista con un placeholder opcional.
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
