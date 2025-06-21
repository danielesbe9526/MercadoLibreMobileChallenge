//
//  MercadoLibreMobileChallengeApp.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

@main
struct MercadoLibreMobileChallengeApp: App {
    let session: APIInteractor
    var fabric: ScreenFabric
    var destination: DestinationViewModel
    let viewModel: HomeViewModel
    
    @StateObject private var colorManager = ThemeManager()
    
    init() {
        session = APIInteractor(session: Session())
        destination = DestinationViewModel()
        viewModel = HomeViewModel(destination: destination, apiInteractor: MLRepositoryCore(apiInteractor: session))
        
        fabric = ScreenFabric(homeViewModel: viewModel)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationWrapperView(destination: destination, fabric: fabric) {
                fabric.createView(item: .homeView)
            }
            .environmentObject(colorManager)
        }
    }
}
