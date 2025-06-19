//
//  HomeView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI


struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var colorManager: ColorManager
    
    let columnsGrid = [GridItem(.adaptive(minimum: 190, maximum: 200))]
    let columnsList = [GridItem(.fixed(350))]
    
    @State private var searchText = ""
    @State private var showInList: Bool = true
    
    var body: some View {
        ViewWrapper {
            VStack {
                HeaderView
                    .padding(13)
                    .background(Color(UIColor(resource: .amarilloML)))
                    .offset(y: -5)
                
                ScrollView {
                    LazyVGrid(columns: showInList ? columnsList : columnsGrid ) {
                        if let products = viewModel.homeProducts {
                            ForEach(products) { product in
                                if showInList {
                                    CardVView(product: product, viewModel: viewModel)
                                        .padding(8)
                                        .onTapGesture {
                                            viewModel.getDetailProduct()
                                            viewModel.routeToDetail()
                                        }
                                } else {
                                    CardHView(product: product, viewModel: viewModel)
                                        .padding(8)
                                        .onTapGesture {
                                            viewModel.routeToDetail()
                                        }
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.5), value: showInList)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        TextField("Buscar...", text: $searchText)
                            .font(.system(size: 12))
                            .padding(5)
                    }
                    .padding(5)
                    .background(Color.white)
                    .cornerRadius(15)
                    .padding(.horizontal, 20)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.black)
                }
            }
            .overlay {
                if !searchText.isEmpty {
                    Rectangle()
                        .background(.gray.opacity(0.3))
                }
            }
            .onAppear {
                viewModel.getHomeProducts()
            }
        }
    }
    
    @ViewBuilder
    var HeaderView: some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: "mappin")
                    .fontWeight(.thin)
                    .font(.system(size: 20))
                Text("Calle posta 4789")
                    .fontWeight(.thin)
                    .font(.system(size: 12))
                Image(systemName: "chevron.right")
                    .fontWeight(.medium)
                    .font(.system(size: 15))
            }
            .padding(5)
            
            Spacer()
            
            HStack {
                Button("", systemImage: "square.grid.2x2") {
                    showInList = false
                }
                .fontWeight(.bold)
                .foregroundStyle(showInList ? .black : colorManager.primaryColor)
                .font(.system(size: 20))
                
                Button("", systemImage: "list.bullet") {
                    showInList = true
                }
                .fontWeight(.bold )
                .foregroundStyle(showInList ? colorManager.primaryColor : .black)
                .font(.system(size: 20))
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
        .environmentObject(ColorManager())
    }
}
