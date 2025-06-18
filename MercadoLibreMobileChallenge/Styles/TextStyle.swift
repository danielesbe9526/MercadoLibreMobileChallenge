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
    case brandChecked
    case previousPrice
    case newPrice
}

struct TextStyle: ViewModifier {
    var style: TextStyles
    
    func body(content: Content) -> some View {
        switch style {
        case .store:
            return content
                .font(.footnote)
            
        case .brand:
            return content
                .font(.subheadline)
        case .tittle:
            return content
                .font(.subheadline)
        case .brandChecked:
            return content
                .font(.subheadline)
            
        case .previousPrice:
            return content
                .font(.subheadline)
        case .newPrice:
            return content
                .font(.subheadline)
        }
    }
}

extension View {
    func textStyle(_ style: TextStyles) -> some View {
        self.modifier(TextStyle(style: style))
    }
}

struct ColorTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .font(.footnote)
            .padding(3)
            .fontWeight(.thin)
            .background(.black)
            .foregroundStyle(.white)
    }
}
