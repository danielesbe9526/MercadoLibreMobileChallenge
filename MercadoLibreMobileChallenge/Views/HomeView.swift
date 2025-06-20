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
    @FocusState private var isTextFieldFocused: Bool

    let columnsGrid = [GridItem(.adaptive(minimum: 190, maximum: 200))]
    let columnsList = [GridItem(.fixed(350))]
    
    @State private var alertModel: AlertModel?
    @State private var searchText = ""
    @State private var showInList: Bool = true
    @State private var showOverlay: Bool = false
    
    @State private var selectedColor: Color = .blue
    @State private var isColorPickerPresented = false
    
    let colors: [Color] = [.red, .green, .blue, .yellow, .orange]

    // Animations
    @Namespace private var searchBarAnimation
    @Namespace private var barAnimation
    @Namespace private var arrowAnimation

    
    let items = ["iPhone", "Samsung", "Pelota"]

    var body: some View {
        ViewWrapper(spinerRun: $viewModel.showSpiner, alertModel: $alertModel) {
            VStack {
                if showOverlay {
                    searchList
                } else {
                    HeaderView
                        .background(Color(UIColor(resource: .amarilloML)))
                        .padding(5)
                    
                    if isColorPickerPresented {
                        HStack {
                            ForEach(colors, id: \.self) { color in
                                Button(action: {
                                    selectedColor = color
                                    colorManager.primaryColor = selectedColor
                                    isColorPickerPresented = false
                                }) {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2)
                                        )
                                }
                                .padding(4)
                            }
                        }
                    }
                    
                    ScrollView {
                        LazyVGrid(columns: showInList ? columnsList : columnsGrid ) {
                            if let products = viewModel.homeProducts {
                                ForEach(products) { product in
                                    if showInList {
                                        CardVView(product: product, viewModel: viewModel)
                                            .padding(.top, 16)
                                            .onTapGesture {
                                                viewModel.getDetailProduct()
                                            }
                                    } else {
                                        CardHView(product: product, viewModel: viewModel)
                                            .padding(.top, 16)
                                            .onTapGesture {
                                                viewModel.getDetailProduct()
                                            }
                                    }
                                }
                            }
                        }
                        .animation(.easeInOut(duration: 0.5), value: showInList)
                    }
                    .background(.white)
                }
            }
            .onAppear {
                viewModel.getHomeProducts()
            }
        }
        .background(Color(UIColor(resource: .amarilloML)))
        .onChange(of: locationManager.errorMessage) { oldValue, newValue in
            if newValue != nil {
                alertModel = AlertModel(title: "🚧 Error obteniendo ubicacion 🚧",
                                        message: newValue,
                                        mainButtonTitle: "got it")
            }
        }
        .onChange(of: viewModel.requestFails) { oldValue, newValue in
//            if newValue {
//                alertModel = AlertModel(title: "🛜 Error obteniendo datos 🛜",
//                                        message: "Por favor verifique su conexion.",
//                                        mainButtonTitle: "got it")
//            }
        }
    }
    
    @ViewBuilder
    var HeaderView: some View {
        VStack(spacing: 10) {
            /// Search Bar
            HStack {
                TextField("", text: $searchText)
                    .placeholder(when: searchText.isEmpty) {
                        Text("Buscar...")
                            .foregroundStyle(.font.opacity(0.5))
                    }
                    .padding(6)
                    .background(Color.white)
                    .cornerRadius(15)
                    .frame(width: 300, height: 30)
                    .matchedGeometryEffect(id: searchBarAnimation, in: barAnimation)
                    .focused($isTextFieldFocused)
                    .onChange(of: isTextFieldFocused) { oldValue, newValue in
                        if newValue {
                            withAnimation(.spring()) {
                                isTextFieldFocused = false
                                showOverlay = true
                            }
                        }
                    }
                    .foregroundStyle(.black)
                
               
                
                Button("", systemImage: "gearshape.fill") {
                    isColorPickerPresented.toggle()
                }
                .foregroundStyle(.black)
            }
            /// Location
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "mappin")
                        .fontWeight(.thin)
                        .font(.system(size: 20))
                    
                    if let placemark = locationManager.placemark {
                        Text("\(placemark.compactAddress ?? "Desconocido")")
                            .fontWeight(.thin)
                            .font(.system(size: 12))
                            .foregroundStyle(.black)
                    }
                   
                    Image(systemName: "chevron.right")
                        .fontWeight(.medium)
                        .font(.system(size: 15))
                        .foregroundStyle(.black)

                }
                .foregroundStyle(.black)
                .padding(.horizontal, 5)
                
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
    
    @ViewBuilder
    var searchView: some View {
        List {
            ForEach(items, id: \.self) { item in
                HStack(spacing: 30) {
                    Image(systemName: "clock")
                        .foregroundColor(.font.opacity(0.6))
                    
                    Text(item)
                        .foregroundColor(.font.opacity(0.6))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.left")
                        .foregroundColor(.font.opacity(0.6))
                }
                .listRowBackground(Color.white)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    withAnimation(.easeOut) {
                        showOverlay = false
                        isTextFieldFocused = false
                    }
                }
            }
        }
        .background(.white)
        .listStyle(PlainListStyle())
    }
    
    @ViewBuilder
    var searchList: some View {
        VStack {
            HStack {
                Button("", systemImage: "arrow.backward") {
                    withAnimation(.spring()) {
                        showOverlay = false
                        isTextFieldFocused = false
                    }
                }
                .matchedGeometryEffect(id: searchBarAnimation, in: arrowAnimation)
                .foregroundStyle(.font)
                .font(.system(size: 30))
                .padding(.leading, 30)
                
                TextField("", text: $searchText)
                    .placeholder(when: searchText.isEmpty) {
                        Text("Buscar en Mercado Libre")
                            .foregroundStyle(.font.opacity(0.5))
                    }
                    .matchedGeometryEffect(id: searchBarAnimation, in: barAnimation)
                    .foregroundColor(.black)
                    .font(.system(size: 16))
                    .frame(width: 350, height: 35)

            }
            .padding(8)
            
            Divider()
            
            searchView
                .padding(.horizontal, 30)
        }
        .background(.white)
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
