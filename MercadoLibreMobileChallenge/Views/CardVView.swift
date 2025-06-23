//
//  CardVView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

struct CardVView: View {
    var product: Product
    @ObservedObject var viewModel: HomeViewModel
    @State var installmentsSTR: String = ""
    @State var samePrice: Bool = false

    @EnvironmentObject var colorManager: ThemeManager

    var body: some View {
        HStack(spacing: 5) {
            productImage
            productDescription
                .padding(5)
            Spacer()
        }
        .onAppear {
            if let installments = product.installments,
               let price = product.originalPrice {
                let response = viewModel.calculatePrice(installments: installments, price: price)
                installmentsSTR = response.message
                samePrice = response.samePrice
            }
        }
    }
    
    @ViewBuilder
    var productImage: some View {
        if let url = URL(string: product.images?.first ?? "") {
            CachedAsyncImage(url: url)
                .frame(width: 150)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .accessibilityHidden(true)
        }
    }
    
    @ViewBuilder
    var productDescription: some View {
        VStack(alignment: .leading, spacing: 5) {
            if let store = product.store {
                Text(store.uppercased())
                    .textStyle(.store)
                    .padding(10)
                    .background(.black)
                    .accessibilityHidden(true)
                    .padding(.vertical, 5)
            }
            
            VStack(alignment: .leading) {
                if let brand = product.brand {
                    Text(brand.uppercased())
                        .textStyle(.brand)
                        .accessibilityHidden(true)
                }
                
                if let name = product.name {
                    Text(product.isAppleSeller ? name + " - " + "Distribuidor Autorizado" : name)
                        .foregroundStyle(colorManager.fontColot)
                        .font(.system(size: 16))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityIdentifier("ProductName")
                        .accessibilityLabel("nombre de el producto: \(name)")
                }
            }
            
            if product.isAppleSeller {
                HStack {
                    Text("Por Apple")
                        .fontWeight(.regular)
                        .foregroundStyle(.gray.opacity(0.5))
                        .font(.system(size: 14))
                        .accessibilityHidden(true)

                    Image(.verified)
                        .resizable()
                        .frame(width: 15, height: 15)
                        .accessibilityHidden(true)
                }
            }
            
            if let rating = product.rating {
                StartsView(rating: rating, numberOfVotes: product.numReviews ?? 0)
                    .padding(.vertical, 5)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Rating del producto, rating de \(Int(rating)), con \(product.numReviews ?? 0) votos")
            }
            
            if let originalPrice = product.originalPrice {
                
                VStack(alignment: .leading) {
                    if let discountedPrice = product.discountedPrice {
                        PriceView(value: originalPrice, size: 14)
                            .foregroundStyle(colorManager.textColor.opacity(0.2))
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("precio anterior de: \(Int(originalPrice))")
                        HStack {
                            PriceView(value: discountedPrice, size: 18)
                                .foregroundStyle(colorManager.textColor)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("nuevo precio de: \(Int(discountedPrice))")
                            
                            let discountPercentage = String(format: "%.1f", product.discountPercentage ?? 0)
                            Text("\(discountPercentage)%OFF")
                                .textStyle(.discount)
                                .accessibilityLabel("descuento de \(discountPercentage)%")
                        }
                    } else {
                        PriceView(value: originalPrice, size: 18)
                            .foregroundStyle(colorManager.textColor)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("precio de: \(Int(originalPrice))")
                    }
                }
                .padding(.vertical, 5)
            }
            
            if samePrice {
                Text("Mismo precio en \(installmentsSTR)")
                    .textStyle(.green12)

            } else if product.installments != nil {
                Text("en \(installmentsSTR)")
                    .font(.system(size: 12))
                    .foregroundStyle(colorManager.fontColot)
            }
           
            if let shipping = product.shipping {
                Text(shipping)
                    .textStyle(.green12)
            }
            Spacer()
        }
    }
}

struct CardVView_Previews: PreviewProvider {
    static let productos = [
        Product(
            id: "27d3cef8dd15dfa932b75fd7apple",
            name: "Soft Concrete Salad",
            store: "Apple tienda oficial",
            brand: "Apple",
            seller: "Alfredo Olivas",
            rating: 2.5382769637012697,
            numReviews: 19060,
            originalPrice: 451668.73,
            discountedPrice: 304234.2158110386,
            discountPercentage: 0.32642178746569717,
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
