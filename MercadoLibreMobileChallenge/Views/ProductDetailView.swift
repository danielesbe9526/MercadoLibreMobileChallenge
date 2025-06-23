//
//  ProductDetailView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

public struct ProductDetailView: View {
    @EnvironmentObject var colorManager: ThemeManager
    @ObservedObject var viewModel: HomeViewModel
   
    @State private var product: ProductDetail?
    @State var installmentsSTR: String = ""
    @State var samePrice: Bool = false

    @State private var selectedImageIndex = 0
    @State private var isFavorite = false
    
    @State var imageUrls: [String] = []
    
    public var body: some View {
        ViewWrapper(showBackButton: true, buttonAction: {
            viewModel.goBack()
        }) {
            VStack {
                ScrollView {
                    VStack {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Nuevo | +100 vendidos")
                                    .font(.system(size: 12))
                                    .foregroundStyle(colorManager.fontColot.opacity(0.8))
                                
                                Spacer()
                                
                                if let rating = product?.rating {
                                    StartsView(rating: rating, numberOfVotes: product?.numReviews ?? 0)
                                }
                            }
                            
                            if let name = product?.name {
                                let message = product?.isAppleSeller ?? false ? "\(name) - Distribuidor Autorizado" : name
                                Text(message)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .lineLimit(nil)
                                    .layoutPriority(1)
                                    .foregroundStyle(colorManager.fontColot)
                                    .font(.system(size: 18))
                                
                            }
                            
                            productImage
                            
                            Spacer()
                            
                            productDescription
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                    }
                    .background(colorManager.backgroundColor)
                }
            }
            .background(colorManager.backgroundColor)
        }
        .onAppear {
            if let productDetail = viewModel.productDetail {
                product = productDetail
            }
            
            if let productImages = product?.images {
                imageUrls = productImages
            }
            
            if let installments = product?.installments?.value,
               let price = product?.originalPrice {
                let response = viewModel.calculatePrice(installments: installments, price: price)
                installmentsSTR = response.message
                samePrice = response.samePrice
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    var productImage: some View {
        ZStack {
            carrusel
            heartButton
            .padding()
        }
    }
    
    @ViewBuilder
    var productDescription: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let originalPrice = product?.originalPrice {
                prices(originalPrice)
            }

            if samePrice {
                Text("Mismo precio en \(installmentsSTR)")
                    .foregroundStyle(colorManager.callToActionColor)
                    .font(.system(size: 14))
            } else if product?.installments != nil {
                Text("en \(installmentsSTR)")
                    .font(.system(size: 12))
                    .foregroundStyle(colorManager.fontColot)
            }
            
            if let alternative = product?.installments?.alternative {
                Text("o mismo precio en \(alternative)")
                    .foregroundStyle(colorManager.fontColot)
                    .font(.system(size: 14))
            }

            Text("Ver los medios de pago")
                .textStyle(.actionLabel)
                .padding(.vertical, 3)
            
            
            if let shipping = product?.shipping {
                Text(shipping)
                    .foregroundStyle(colorManager.callToActionColor)
                    .font(.system(size: 14))
                    .padding(.top, 15)
            }
            
            Text("Mas formas de entrega")
                .textStyle(.actionLabel)
                .padding(.vertical, 3)
            
            
            VStack(alignment: .leading) {
                Text("Retira gratis a partir del sabado en correos y otros puntos")
                    .foregroundStyle(colorManager.callToActionColor)
                    .font(.system(size: 14))
                    .padding(.top, 15)
                
                Text("Tienes un punto de entrega a 450m")
                    .foregroundStyle(colorManager.fontColot.opacity(0.4))
                    .font(.system(size: 12))
                    .padding(.vertical, 3)
                
                Text("Ver en el mapa")
                    .textStyle(.actionLabel)
            }
            
            Text("Stock disponible")
                .foregroundStyle(colorManager.fontColot)
                .font(.system(size: 14))
                .padding(.vertical,15)
            
            
            Group {
                HStack {
                    Text("Cantidad: 1")
                        .foregroundStyle(colorManager.fontColot)
                    
                    Text("(+10 disponibles)")
                        .foregroundStyle(colorManager.textColor.opacity(0.1))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(colorManager.primaryColor)
                        .fontWeight(.medium)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 3))
            
            VStack {
                Button {
                    // TODO: - do something
                } label: {
                    Text("Comprar ahora")
                        .fontWeight(.light)
                        .foregroundStyle(colorManager.backgroundColor)
                        .padding(.vertical, 15)
                }
                .frame(maxWidth: .infinity)
                .background(colorManager.primaryColor)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Button {
                    // TODO: - do something
                } label: {
                    Text("Agregar al carrito")
                        .fontWeight(.light)
                        .foregroundStyle(colorManager.primaryColor)
                        .padding(.vertical, 15)
                }
                .frame(maxWidth: .infinity)
                .background(colorManager.primaryColor.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 5))
     
            }
            .padding(.vertical)
            
            if let description = product?.description {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Descripcion")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(colorManager.textColor)
                    
                    Text(description)
                        .font(.system(size: 12))
                        .foregroundStyle(colorManager.fontColot)
                }
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func prices(_ originalPrice: Double) -> some View {
        VStack(alignment: .leading) {
            if let discountedPrice = product?.discountedPrice {
                HStack {
                    PriceView(value: discountedPrice, size: 26)
                        .foregroundStyle(colorManager.textColor)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("precio de: \(Int(discountedPrice))")
                    
                    let discountPercentage = String(format: "%.1f", product?.discountPercentage ?? 0)
                    Text("\(discountPercentage)%OFF")
                        .font(.system(size: 18))
                        .foregroundStyle(colorManager.callToActionColor)
                        .accessibilityLabel("descuento de \(discountPercentage)%")

                }
            } else {
                PriceView(value: originalPrice, size: 18)
                    .foregroundStyle(colorManager.textColor)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("precio de: \(Int(originalPrice))")
            }
        }
    }
    
    @ViewBuilder
    var heartButton: some View {
        VStack {
            HStack {
                
                Text("\(selectedImageIndex + 1)/\(imageUrls.count)")
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .font(.system(size: 12, weight: .medium))
                    .background(.gray.opacity(0.1))
                    .foregroundStyle(colorManager.fontColot)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Spacer()
                Button(action: {
                    withAnimation(.snappy) {
                        isFavorite.toggle()
                    }
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 22, height: 20)
                        .foregroundStyle(colorManager.primaryColor)
                        .padding()
                        .foregroundColor(isFavorite ? colorManager.primaryColor : .gray)
                }
                .background(.gray.opacity(0.1))
                .clipShape(Circle())
            }
            Spacer()
        }
    }

    @ViewBuilder
    var carrusel: some View {
        VStack {
            Spacer()
            
            TabView(selection: $selectedImageIndex) {
                ForEach(0..<imageUrls.count, id: \.self) { index in
                    if let url =  URL(string: imageUrls[index]) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .tag(index)
                        } placeholder: {
                            Color.gray.opacity(0.1)
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(minHeight: 350)

            HStack {
                ForEach(0..<imageUrls.count, id: \.self) { index in
                    Circle()
                        .fill(index == selectedImageIndex ? colorManager.primaryColor : Color.gray.opacity(0.2))
                        .frame(width: 10, height: 10)
                }
            }
            .padding(.top)
            
            Spacer()
        }
    }
    
    public init(product: ProductDetail, viewModel: HomeViewModel) {
        self.product = product
        self.viewModel = viewModel
    }
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
}

struct ProductDetailView_Previews: PreviewProvider {

    static let viewModel = HomeViewModel()
    
    static var previews: some View {
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

