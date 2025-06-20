//
//  TextStyle.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation
import SwiftUI

enum TextStyles {
    case store
    case brand
    case tittle
    case green12
    case discount
    case actionLabel
}

struct TextStyle: ViewModifier {
    var style: TextStyles
    @EnvironmentObject var colorManager: ColorManager

    func body(content: Content) -> some View {
        switch style {
        case .store:
            return content
                .font(.system(size: 12, weight: .thin))
                .foregroundColor(.white)
            
        case .brand:
            return content
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.black)
        case .tittle:
            return content
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.font)
            
        case .green12:
            return content
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.verdeML)
        
        case .discount:
            return content
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.verdeML)
        
        case .actionLabel:
            return content
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(colorManager.primaryColor.opacity(0.5))
        }
    }
}

extension View {
    func textStyle(_ style: TextStyles) -> some View {
        self.modifier(TextStyle(style: style))
    }
}

extension View {
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
