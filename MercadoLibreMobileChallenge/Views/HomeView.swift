//
//  HomeView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var colorManager: ThemeManager
    @StateObject private var locationManager = LocationManager()
    @FocusState private var isTextFieldFocused: Bool

    let columnsGrid = [GridItem(.fixed((UIScreen.main.bounds.width/2) - 10)), GridItem(.fixed((UIScreen.main.bounds.width/2) - 10))]
    let columnsList = [GridItem(.fixed(UIScreen.main.bounds.width - 16))]
    
    @State private var alertModel: AlertModel?
    @State private var showInList: Bool = true
        
    var body: some View {
        ViewWrapper(spinerRun: $viewModel.showSpiner, alertModel: $alertModel, showInList: $showInList, otherThemeTapped: {
            viewModel.routeToDeveloper()
        }) {
            VStack {
                ScrollView {
                    LazyVGrid(columns: showInList ? columnsList : columnsGrid ) {
                        if let products = viewModel.homeProducts {
                            ForEach(products) { product in
                                if showInList {
                                    CardVView(product: product, viewModel: viewModel)
                                        .padding(8)
                                        .onTapGesture {
                                            viewModel.getDetailProduct()
                                        }
                                        .background(colorManager.backgroundColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                                        .accessibilityIdentifier("Cardv")
                                        .accessibilityElement(children: .combine)
                                        .accessibilityHint("Toca dos veces para ver mas detalles")
                                        .accessibilityAction {
                                            viewModel.getDetailProduct()
                                        }
                                    
                                } else {
                                    CardHView(product: product, viewModel: viewModel)
                                        .padding(.top, 16)
                                        .onTapGesture {
                                            viewModel.getDetailProduct()
                                        }
                                        .frame(height: 500)
                                        .background(colorManager.backgroundColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .shadow(color: .black.opacity(0.1), radius: 20, x: 5, y: 5)
                                        .accessibilityIdentifier("CardH")
                                        .accessibilityElement(children: .combine)
                                        .accessibilityHint("Toca dos veces para ver mas detalles")
                                        .accessibilityAction {
                                            viewModel.getDetailProduct()
                                        }
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: showInList)
                }
                .padding(.top, 10)
                .background(.gray.opacity(0.1))
                
            }
            .onAppear {
                viewModel.getHomeProducts()
            }
            .background(colorManager.backgroundColor)
        }
        .onChange(of: locationManager.errorMessage) { oldValue, newValue in
            if newValue != nil {
                alertModel = AlertModel(title: "🚧 Error obteniendo ubicacion 🚧",
                                        message: newValue,
                                        mainButtonTitle: "ok")
            }
        }
        .onChange(of: viewModel.requestFails) { oldValue, newValue in
            if newValue {
                alertModel = AlertModel(title: "🛜 Error obteniendo datos 🛜",
                                        message: "Por favor verifique su conexion.",
                                        mainButtonTitle: "got it")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static let productos = [
        Product(
            id: "27d3cef8dd15dfa932b75fd7apple",
            name: "Soft Concrete Salad",
            store: "Apple tienda oficial",
            brand: "Apple",
            seller: "Alfredo Olivas",
            rating: 2.5382769637012697,
            numReviews: 19060,
            originalPrice: 680374.49,
            discountedPrice: 557537.9185789034,
            discountPercentage: 0.18054258827531378,
            installments: "12 cuotas de 56697.87416666667",
            shipping: "Envío gratis",
            images: [
                "https://picsum.photos/seed/L0Gf5/200/200",
                "https://picsum.photos/seed/RrcsEJ/200/200",
                "https://picsum.photos/seed/rHcqXsr1Az/200/200?grayscale",
                "https://picsum.photos/seed/pX2iFS/200/200?grayscale",
                "https://picsum.photos/seed/i9zeV9KXP0/200/200?grayscale",
                "https://picsum.photos/seed/qQLtead9qx/200/200?grayscale",
                "https://picsum.photos/seed/SzfeCGMX/200/200"
            ]
        ),
        
        Product(
            id: "f7ce9b9bc9e68fc795d99f50apple",
            name: "Frozen Silk Bacon",
            store: "Apple tienda oficial",
            brand: "Apple",
            seller: "Lauryn Hill",
            rating: 3.5090663386422865,
            numReviews: 53450,
            originalPrice: 938242.45,
            discountedPrice: 556260.3153000555,
            discountPercentage: 0.4071251889103338,
            installments: "7 cuotas de 134034.63571428572",
            shipping: nil,
            images: [
                "https://picsum.photos/seed/eLBvFiL/200/200"
            ]
        )
    ]
    static let viewModel = HomeViewModel(homeProducts: productos)
    
    static var previews: some View {
        NavigationWrapperView(destination: DestinationViewModel(), fabric: ScreenFabric(homeViewModel: viewModel)) {
                HomeView(viewModel: viewModel)
        }
        .environmentObject(ThemeManager())
    }
}
