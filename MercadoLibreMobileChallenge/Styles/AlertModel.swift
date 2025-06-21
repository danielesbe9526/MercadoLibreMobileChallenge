//
//  AlertModel.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation
import SwiftUI

/// `AlertModel` es una estructura que define el contenido y las acciones de una alerta personalizada.
public struct AlertModel {
    
    /// Título de la alerta.
    public var title: String
    
    /// Mensaje opcional de la alerta.
    public var message: String?
    
    /// Título del botón principal opcional.
    public var mainButtonTitle: String?
    
    /// Título del segundo botón opcional.
    public var secondButtonTitle: String?
    
    /// Acción que se ejecuta al presionar el botón principal.
    public var mainButtonAction: (() -> Void)?
    
    /// Acción que se ejecuta al presionar el segundo botón.
    public var secondButtonAction: (() -> Void)?
    
    /// Inicializador para `AlertModel`.
    /// - Parameters:
    ///   - title: Título de la alerta.
    ///   - message: Mensaje opcional de la alerta.
    ///   - mainButtonTitle: Título opcional del botón principal.
    ///   - secondButtonTitle: Título opcional del segundo botón.
    ///   - mainButtonAction: Acción opcional para el botón principal.
    ///   - secondButtonAction: Acción opcional para el segundo botón.
    public init(title: String, message: String? = nil, mainButtonTitle: String? = nil, secondButtonTitle: String? = nil, mainButtonAction: (() -> Void)? = nil, secondButtonAction: (() -> Void)? = nil) {
        self.title = title
        self.message = message
        self.mainButtonTitle = mainButtonTitle
        self.secondButtonTitle = secondButtonTitle
        self.mainButtonAction = mainButtonAction
        self.secondButtonAction = secondButtonAction
    }
    
    /// Inicializador por defecto para `AlertModel`.
    public init() {
        self.title = ""
        self.message = nil
        self.mainButtonTitle = ""
        self.secondButtonTitle = nil
        self.mainButtonAction = nil
        self.secondButtonAction = nil
    }
}

extension AlertModel {
    
    /// Crea una alerta por defecto.
    /// - Parameter mainButtonAction: Acción opcional para el botón principal.
    /// - Returns: Un `AlertModel` configurado con valores por defecto.
    static func defaultAlert(mainButtonAction: (() -> Void)? = nil) -> AlertModel {
        AlertModel(title: "ERROR",
                   message: "Some error Appear",
                   mainButtonTitle: "got it",
                   mainButtonAction: mainButtonAction)
    }
}
