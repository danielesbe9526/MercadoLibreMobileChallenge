//
//  ViewWrapper.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

public struct ViewWrapper<Content: View>: View {
    /// Indica si el spinner de carga está activo.
    @Binding var spinerRun: Bool

    /// Modelo de alerta opcional para mostrar notificaciones al usuario.
    @Binding var alertModel: AlertModel?

    /// Indica si los elementos deben mostrarse en una lista.
    @Binding var showInList: Bool

    /// Estado del enfoque para un campo de texto.
    @FocusState private var isTextFieldFocused: Bool

    /// Objeto que maneja el tema de color de la aplicación.
    @EnvironmentObject var colorManager: ThemeManager

    /// Indica si el selector de color está presentado.
    @State private var isColorPickerPresented = false

    /// Color seleccionado actualmente.
    @State private var selectedColor: Color = .blue

    /// Indica si se debe mostrar una superposición.
    @State var showOverlay: Bool = false

    /// Texto de búsqueda introducido por el usuario.
    @State var searchText: String = ""

    /// Gestor de ubicación para manejar datos de localización.
    @StateObject private var locationManager = LocationManager()

    /// Contenido de la vista.
    var content: () -> Content

    /// Indica si se debe mostrar el botón de retroceso.
    var showBackButton: Bool

    /// Acción a ejecutar cuando se presiona el botón.
    var buttonAction: (() -> Void)?

    /// Indica si se debe mostrar el encabezado.
    var showHeader: Bool

    /// Acción a ejecutar cuando se selecciona otro tema.
    var otherThemeTapped: (() -> Void)?

    // Animaciones

    /// Espacio de nombres para animaciones de la barra de búsqueda.
    @Namespace private var searchBarAnimation

    /// Espacio de nombres para animaciones de la barra.
    @Namespace private var barAnimation

    /// Espacio de nombres para animaciones de la flecha.
    @Namespace private var arrowAnimation

    /// Elementos de muestra para mostrar en la lista.
    let items = ["iPhone", "Samsung", "Pelota"]

    /// Colores disponibles para seleccionar.
    let colors: [Color] = [.red, .green, .blue, .yellow, .orange]

    /// Inicializador para configurar la vista.
    /// - Parameters:
    ///   - spinerRun: Indica si el spinner de carga está activo.
    ///   - alertModel: Modelo de alerta opcional.
    ///   - showHeader: Indica si se debe mostrar el encabezado.
    ///   - showInList: Indica si los elementos deben mostrarse en una lista.
    ///   - showBackButton: Indica si se debe mostrar el botón de retroceso.
    ///   - buttonAction: Acción a ejecutar cuando se presiona el botón.
    ///   - otherThemeTapped: Acción a ejecutar cuando se selecciona otro tema.
    ///   - content: Contenido de la vista.
    public init(spinerRun: Binding<Bool> = .constant(false),
                alertModel: Binding<AlertModel?> = .constant(nil),
                showHeader: Bool = true,
                showInList: Binding<Bool> = .constant(false),
                showBackButton: Bool = false,
                buttonAction: (() -> Void)? = nil,
                otherThemeTapped: (() -> Void)? = nil,
                @ViewBuilder content: @escaping () -> Content) {
        self._spinerRun = spinerRun
        self._alertModel = alertModel
        self.content = content
        self.showHeader = showHeader
        self._showInList = showInList
        self.showBackButton = showBackButton
        self.buttonAction = buttonAction
        self.otherThemeTapped = otherThemeTapped
    }
    
    public var body: some View {
        ZStack {
            VStack {
                if showHeader {
                    if showOverlay {
                        searchList
                    } else {
                        HeaderView
                        
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
                                Circle()
                                    .fill(
                                        RadialGradient(
                                            gradient: Gradient(colors: colors),
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 40
                                        )
                                    )
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text("Other")
                                            .font(.system(size: 8))
                                    )
                                    .onTapGesture {
                                        otherThemeTapped?()
                                        isColorPickerPresented = false
                                    }
                            }
                        }
                        content()
                    }
                } else {
                    content()
                }
            }
            if let alertModel {
                Alert(showView: true, model: alertModel)
                    .zIndex(9)
            }

            if spinerRun {
                ProgressView()
                    .frame(width: 45.0, height: 45.0)
            }
        }
        .padding(.top, 5)
    }
    
    @ViewBuilder
    var HeaderView: some View {
        VStack(spacing: 10) {
            /// Search Bar
            
            HStack {
                if showBackButton {
                    Button("", systemImage: "arrow.backward") {
                        buttonAction?()
                    }
                    .foregroundStyle(colorManager.textColor.opacity(0.6))
                    .font(.system(size: 30))
                    .matchedGeometryEffect(id: arrowAnimation, in: barAnimation)
                    .padding(.leading, 6)
                } else {
                    Spacer()
                }
                
                Spacer()
                
                TextField("", text: $searchText)
                    .placeholder(when: searchText.isEmpty) {
                        Text("Buscar...")
                            .foregroundStyle(.font.opacity(0.5))
                    }
                    .padding(6)
                    .background(colorManager.backgroundColor)
                    .cornerRadius(15)
                    .frame(width: 310, height: 30)
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
                    .foregroundStyle(colorManager.textColor)
                
                Spacer()
                
                if !showBackButton {
                    Button("", systemImage: "gearshape.fill") {
                        isColorPickerPresented.toggle()
                    }
                    .foregroundStyle(colorManager.textColor)
                    .font(.system(size: 20))
                }
                Spacer()
            }
            
            /// Location
            HStack {
                HStack(spacing: 10) {
                    Image(.marcador)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(colorManager.textColor)
                    
                    if let placemark = locationManager.placemark {
                        Text("\(placemark.compactAddress ?? "Desconocido")")
                            .fontWeight(.thin)
                            .font(.system(size: 12))
                            .foregroundStyle(colorManager.textColor)
                    }
                    
                    Image(systemName: "chevron.right")
                        .fontWeight(.medium)
                        .font(.system(size: 15))
                        .foregroundStyle(colorManager.textColor)
                    
                }
                .foregroundStyle(colorManager.textColor)
                .padding(.horizontal, 5)
                
                Spacer()
                
                if !showBackButton {
                    HStack {
                        Button("", systemImage: "square.grid.2x2") {
                            showInList = false
                        }
                        .fontWeight(.bold)
                        .foregroundStyle(showInList ? colorManager.textColor : colorManager.primaryColor)
                        .font(.system(size: 20))
                        
                        Button("", systemImage: "list.bullet") {
                            showInList = true
                        }
                        .fontWeight(.bold )
                        .foregroundStyle(showInList ? colorManager.primaryColor : colorManager.textColor)
                        .font(.system(size: 20))
                    }
                }
            }
        }
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
                .foregroundStyle(colorManager.fontColot)
                .font(.system(size: 30))
                .padding(.leading, 30)
                
                TextField("", text: $searchText)
                    .placeholder(when: searchText.isEmpty) {
                        Text("Buscar en Mercado Libre")
                            .foregroundStyle(colorManager.fontColot.opacity(0.5))
                    }
                    .matchedGeometryEffect(id: searchBarAnimation, in: barAnimation)
                    .foregroundColor(colorManager.textColor)
                    .font(.system(size: 16))
                    .frame(width: 350, height: 35)

            }
            .padding(8)
            
            Divider()
            
            searchView
                .padding(.horizontal, 30)
        }
        .background(colorManager.backgroundColor)
    }
    
    @ViewBuilder
    var searchView: some View {
        List {
            ForEach(items, id: \.self) { item in
                HStack(spacing: 30) {
                    Image(systemName: "clock")
                        .foregroundColor(colorManager.fontColot.opacity(0.6))
                    
                    Text(item)
                        .foregroundColor(colorManager.fontColot.opacity(0.6))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.left")
                        .foregroundColor(colorManager.fontColot.opacity(0.6))
                }
                .listRowBackground(colorManager.backgroundColor)
                .listRowSeparator(.hidden)
                .onTapGesture {
                    withAnimation(.easeOut) {
                        showOverlay = false
                        isTextFieldFocused = false
                    }
                }
            }
        }
        .background(colorManager.backgroundColor)
        .listStyle(PlainListStyle())
    }
}


struct ViewWrapper_Previews: PreviewProvider {

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
        Group {
            
            NavigationWrapperView(destination: DestinationViewModel(), fabric: ScreenFabric(homeViewModel: viewModel)) {
                HomeView(viewModel: viewModel)
            }
            .environmentObject(ThemeManager())
            
            NavigationWrapperView(
                destination: DestinationViewModel(),
                fabric: ScreenFabric(homeViewModel: viewModel)) {
                    ProductDetailView(
                        product: ProductDetail(
                            id: "1apple",
                            name: "Incredible Bronze Soap",
                            store: "Apple tienda oficial",
                            brand: "Apple",
                            seller: "Hillsong UNITED",
                            rating: 3.919049083585603,
                            numReviews: 406251,
                            originalPrice: 1786384.85,
                            discountedPrice: 1410331.6005621327,
                            discountPercentage: 0.21051076952307757,
                            stock: 15,
                            installments: Installments(
                                value: "9 cuotas de 198487.20555555556",
                                alternative: "3639149146068879 cuotas sin tarjeta"
                            ),
                            shipping: "Llega Mañana",
                            images: [
                                "https://picsum.photos/seed/bNsG7iK/720/720",
                                "https://picsum.photos/seed/qhrEL/720/720?grayscale",
                                "https://picsum.photos/seed/vuLrrBdieN/720/720?grayscale",
                                "https://picsum.photos/seed/dyToMMlJVD/720/720",
                                "https://picsum.photos/seed/e02WFUHQ5M/720/720?grayscale",
                                "https://picsum.photos/seed/ubdaK/720/720?grayscale",
                                "https://picsum.photos/seed/ZGLjeMgP9/720/720?grayscale"
                            ],
                            description: "Censura animadverto eum ago utpote tot peccatus decimus debilito quis. Tollo cornu acsi stillicidium nobis curiositas benevolentia. Aiunt vigor cupiditas adeptio solutio cauda tergiversatio acies colligo. Aurum vindico nisi aetas averto animi comburo. Ustilo succedo theca summa confero solvo tego. Vobis suppellex vehemens curso cruciamentum alo talio suasoria clam. Appono crudelis defessus ambitus. Thesis terga aspicio. Minus alias sed cornu. Cetera totus surgo videlicet. Blanditiis id velociter vallum degenero carus tabgo capio aliquam. Traho facere uberrime arca ante. Summopere adsum desino. Articulus solus cognatus defetiscor coniecto admoneo tertius. Adnuo caecus calculus nam commodi adversus adfero commemoro. Ex tondeo cicuta cariosus venio. Canonicus cernuus admiratio aspernatur placeat conturbo verbera incidunt tres stultus. Vesper absens nam adflicto vehemens audax textor cotidie pariatur. Ipsam conatus valetudo. Aggredior approbo calcar advoco capitulus uxor talis. Comedo vestigium tactus apostolus. Vitium at utpote summisse stabilis. Statua cogo combibo. Vacuus abbas assumenda constans. Temptatio trucido sollers viridis cotidie supplanto. Ago universe vinculum. Tui vulnus a corporis capitulus acer adeo. Stultus ultio consectetur vesco vitiosus tyrannus callide solitudo rerum. Utrum decumbo arguo umbra solutio cattus. Cibo despecto canto. Depraedor audentia nemo. Commodo temporibus censura crebro repellendus suffoco tamen textus. Correptius molestiae eveniet charisma viriliter comminor collum porro ratione traho. Solus aveho decens cariosus unus tremo. Depopulo vulnus cauda credo a. Carmen defendo peior absum. Deleo apto caelestis umerus coadunatio cruentus vesica terreo. Bardus confero cetera conculco. Volo cuppedia ver thymum tendo atque campana absconditus templum. Antepono harum sto alioqui claudeo praesentium umerus suggero sperno. Statim voluptatem adimpleo stillicidium via terra coniuratio ex. Supra aut aeternus conspergo terga vir. Aiunt inventore communis tempus aveho cunae contra. Cubitum sumo cedo terminatio doloribus. Quae sortitus tener aestus subseco. Teres adnuo demonstro. Argentum venia carpo constans amaritudo thesis arcesso maxime blanditiis careo. Amissio approbo acerbitas. Officia cimentarius civis cohaero sono. Conforto vigilo carmen summa vulticulus solio dignissimos. Ambitus summopere perspiciatis caput amplitudo dolores timor eligendi assentator veniam. Sulum optio aptus."
                        ),
                        viewModel: HomeViewModel()
                    )
                }
                .environmentObject(ThemeManager())
        }
    }
}
