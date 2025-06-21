//
//  Alert.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

/// `Alert` es una vista que muestra una alerta personalizada con un título y animaciones para su aparición y desaparición.
public struct Alert: View {
    
    /// Estado para controlar la visibilidad de la vista de alerta.
    @State private var showView: Bool
    
    /// Modelo que contiene la información para la alerta.
    var model: AlertModel
    
    public var body: some View {
        ZStack(alignment: .topLeading) {
            if showView {
                alertBody
                    .frame(
                        width: UIScreen.main.bounds.width * 0.9,
                        height: UIScreen.main.bounds.height * 0.3
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .top),
                        removal: .move(edge: .top)
                    ))
                    .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    .onTapGesture {
                        withAnimation {
                            self.showView = false
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                self.showView = false
                            }
                        }
                    }
            }
        }
        .offset(y: -UIScreen.main.bounds.height * 0.35)
    }
    
    /// Inicializador para `Alert`.
    /// - Parameters:
    ///   - showView: Estado inicial de visibilidad de la alerta.
    ///   - model: Modelo que contiene el título de la alerta y otra información.
    public init(showView: Bool, model: AlertModel) {
        self.showView = showView
        self.model = model
    }
    
    /// Cuerpo de la alerta que incluye el título y el icono.
    public var alertBody: some View {
        Label(model.title, systemImage: "antenna.radiowaves.left.and.right.slash")
            .fontWeight(.bold)
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

#Preview {
    Alert(showView: true, model: AlertModel(title: "title", mainButtonTitle: "button", mainButtonAction: nil))
}
