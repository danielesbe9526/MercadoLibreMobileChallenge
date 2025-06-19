//
//  ColorManager.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 19/06/25.
//

import Foundation
import SwiftUI

class ColorManager: ObservableObject {
    @Published var primaryColor: Color = .azulML
    
    func changeColor(_ color: Color) {
        self.primaryColor = color
    }
}
