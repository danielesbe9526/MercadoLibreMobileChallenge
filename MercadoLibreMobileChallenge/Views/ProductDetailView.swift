//
//  ProductDetailView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

public struct ProductDetailView: View {
    @State private var product: ProductDetail
    @ObservedObject var viewModel: HomeViewModel
    @State var installmentsSTR: String = ""

    public var body: some View {
        ViewWrapper {
            ScrollView {
                VStack {
                    HeaderView
                        .padding(13)
                        .background(Color(UIColor(resource: .amarilloML)))
                        .offset(y: -5)
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Nuevo | +100 vendidos")
                                .font(.system(size: 12))
                                .foregroundStyle(.gray.opacity(0.8))
                            
                            Spacer()
                            
                            if let rating = product.rating {
                                StartsView(rating: rating, numberOfVotes: product.numReviews ?? 0)
                            }
                        }
                        
                        if let name = product.name {
                            Text(product.isAppleSeller ? name + " - " + "Distribuidor Autorizado" : name)
                                .foregroundStyle(.font)
                                .font(.system(size: 18))
                        }
                        
                        productImage
                        
                        Spacer()
                        
                        productDescription
                    }
                    .padding(.horizontal, 8)
                }
            }
            .onAppear {
                if let installments = product.installments?.value,
                   let price = product.originalPrice {
                    installmentsSTR = viewModel.calculatePrice(installments: installments, price: price)
                }
            }
        }
    }
    
    @ViewBuilder
    var productImage: some View {
        AsyncImage(url: URL(string: product.images?.first ?? "")) { phase in
            switch phase {
            case .empty, .failure(_):
                Image(systemName: "photo.fill")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.gray.opacity(0.2))
                    .scaledToFit()
                
            case .success(let image):
                image
                    .resizable()
                    .frame(maxHeight: 200)
                    .scaledToFit()
                
            @unknown default:
                Image(systemName: "photo.fill")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(.gray.opacity(0.2))
                    .frame(maxHeight: 200)
            }
        }
    }
    
    @ViewBuilder
    var productDescription: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let originalPrice = product.originalPrice {
                prices(originalPrice)
            }
            
            if viewModel.showSamePrice {
                Text("Mismo precio en \(installmentsSTR)")
                    .foregroundStyle(.green)
                    .font(.system(size: 14))
            } else if product.installments != nil {
                Text(viewModel.installmentsMessage)
                    .font(.system(size: 12))
                
            }
            
            if let alternative = product.installments?.alternative {
                Text("o mismo precio en \(alternative)")
                    .foregroundStyle(.font)
                    .font(.system(size: 14))
            }

            Text("Ver los medios de pago")
                .foregroundStyle(.font.opacity(0.4))
                .font(.system(size: 10))
                .padding(.vertical, 3)
            
            
            if let shipping = product.shipping {
                Text(shipping)
                    .foregroundStyle(.green)
                    .font(.system(size: 12))
                    .padding(.top, 15)
            }
            
            Text("Mas formas de entrega")
                .foregroundStyle(.font.opacity(0.4))
                .font(.system(size: 10))
                .padding(.vertical, 3)
            
            
            Spacer()
        }
    }
    
    @ViewBuilder
    func prices(_ originalPrice: Double) -> some View {
        VStack(alignment: .leading) {
            if let discountedPrice = product.discountedPrice {
                HStack {
                    PriceView(value: discountedPrice, size: 26)
                    
                    let discountPercentage = String(format: "%.1f", product.discountPercentage ?? 0)
                    Text("\(discountPercentage)%OFF")
                        .font(.system(size: 18))
                        .foregroundStyle(.green)
                }
            } else {
                PriceView(value: originalPrice, size: 18)
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
        }
    }
    
    public init(product: ProductDetail, viewModel: HomeViewModel) {
        self.product = product
        self.viewModel = viewModel
    }
}

#Preview {
    
    NavigationWrapperView(
        destination: DestinationViewModel(),
        fabric: ScreenFabric(homeViewModel: HomeViewModel(destination: nil))) {
            ProductDetailView(product:
                               ProductDetail(
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
                               )
                              
                              , viewModel: HomeViewModel()
            )
        }
}
