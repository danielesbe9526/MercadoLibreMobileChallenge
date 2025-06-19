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
    @StateObject private var locationManager = LocationManager()

    let columnsGrid = [GridItem(.adaptive(minimum: 190, maximum: 200))]
    let columnsList = [GridItem(.fixed(350))]
    
    @State private var alertModel: AlertModel?
    @State private var searchText = ""
    @State private var showInList: Bool = true
    @State private var showOverlay: Bool = false

    let items = ["iPhone", "Samsung", "Pelota"]

    var body: some View {
        ViewWrapper(spinerRun: $viewModel.showSpiner, alertModel: $alertModel) {
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
            .animation(.easeInOut(duration: 0.5), value: showOverlay)
            .toolbar {
                if !showOverlay {
                    ToolbarItem(placement: .principal) {
                        TextField("Buscar...", text: $searchText)
                            .font(.system(size: 12))
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding(.horizontal, 20)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.black)
                    }
                }
                
            }
            .overlay {
                if showOverlay {
                    Color.white
                        .ignoresSafeArea(.all)
                    VStack {
                        HStack {
                            Button("", systemImage: "arrow.backward") {
                                showOverlay = false
                            }
                            
                            TextField("Buscar en Mercado Libre", text: $searchText)
                        }
                        .padding()
                        
                        Divider()
                        
                        searchView
                    }
                }
            }
            .onAppear {
                viewModel.getHomeProducts()
            }
        }
        .onChange(of: locationManager.errorMessage) { oldValue, newValue in
            if newValue != nil {
                alertModel = AlertModel(title: "🚧 Error obteniendo ubicacion 🚧",
                                        message: newValue,
                                        mainButtonTitle: "got it")
            }
        }
        .onChange(of: viewModel.requestFails) { oldValue, newValue in
            if newValue {
                alertModel = AlertModel(title: "🛜 Error obteniendo datos 🛜",
                                        message: "Por favor verifique su conexion.",
                                        mainButtonTitle: "got it")
            }
        }
        .onChange(of: searchText) { oldValue, newValue in
            showOverlay = !newValue.isEmpty
        }
    }
    
    @ViewBuilder
    var HeaderView: some View {
        HStack {
            HStack(spacing: 10) {
                Image(systemName: "mappin")
                    .fontWeight(.thin)
                    .font(.system(size: 20))
                
                if let placemark = locationManager.placemark {
                    Text("\(placemark.compactAddress ?? "Desconocido")")
                        .fontWeight(.thin)
                        .font(.system(size: 12))
                }
               
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
    
    @ViewBuilder
    var searchView: some View {

        VStack(spacing: 0) {
            List {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.font.opacity(0.6))
                        Text(item)
                            .foregroundColor(.font.opacity(0.6))
                        Spacer()
                        Image(systemName: "arrow.up.left")
                            .foregroundColor(.font.opacity(0.6))
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .ignoresSafeArea(.all)
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
