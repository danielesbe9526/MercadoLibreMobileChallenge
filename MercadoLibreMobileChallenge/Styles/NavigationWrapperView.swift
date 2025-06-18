//
//  NavigationWrapperView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

struct NavigationWrapperView<Content: View>: View {
    @ObservedObject var destination: DestinationViewModel
    var fabric: ScreenFabric
    var content: () -> Content
    
    init(destination: DestinationViewModel, fabric: ScreenFabric, @ViewBuilder content: @escaping () -> Content) {
        self.destination = destination
        self.fabric = fabric
        self.content = content
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(resource: .amarilloML)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack(path: $destination.destination) {
            content()
                .navigationDestination(for: ScreenDestination.self) {
                    fabric.createView(item: $0)
                }
        }
        .background(.yellow)
    }
}
