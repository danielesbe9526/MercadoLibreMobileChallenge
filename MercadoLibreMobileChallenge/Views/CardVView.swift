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
    
    var body: some View {
        HStack(spacing: 5) {
            productImage
            Spacer()
            productDescription
        }
        .onAppear {
            if let installments = product.installments,
               let price = product.originalPrice {
                installmentsSTR = viewModel.calculatePrice(installments: installments, price: price)
            }
        }
    }
    
    @ViewBuilder
    var productImage: some View {
        if let url = URL(string: product.images?.first ?? "") {
            CachedAsyncImage(url: url)
                .frame(maxWidth: 150)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
    
    @ViewBuilder
    var productDescription: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let store = product.store {
                Text(store.uppercased())
                    .textStyle(.store)
                    .padding(3)
                    .background(.black)
                
            }
            
            VStack(alignment: .leading) {
                if let brand = product.brand {
                    Text(brand.uppercased())
                        .textStyle(.brand)
                }
                
                if let name = product.name {
                    Text(product.isAppleSeller ? name + " - " + "Distribuidor Autorizado" : name)
                        .foregroundStyle(.font)
                        .font(.system(size: 16))
                }
            }
            
            if product.isAppleSeller {
                HStack {
                    Text("Por Apple")
                        .fontWeight(.regular)
                        .foregroundStyle(.gray.opacity(0.5))
                        .font(.system(size: 14))

                    Image(.verified)
                        .resizable()
                        .frame(width: 15, height: 15)
                    
                }
            }
            
            if let rating = product.rating {
                StartsView(rating: rating, numberOfVotes: product.numReviews ?? 0)
            }
            
            if let originalPrice = product.originalPrice {
                
                VStack(alignment: .leading) {
                    if let discountedPrice = product.discountedPrice {
                        PriceView(value: discountedPrice, size: 14)
                            .foregroundStyle(.gray.opacity(0.6))
                        
                        HStack {
                            PriceView(value: originalPrice, size: 20)
                                .foregroundStyle(.black)

                            let discountPercentage = String(format: "%.1f", product.discountPercentage ?? 0)
                            Text("\(discountPercentage)%OFF")
                                .textStyle(.discount)
                        }
                    } else {
                        PriceView(value: originalPrice, size: 18)
                            .foregroundStyle(.black)
                    }
                }
            }
            
            if viewModel.showSamePrice {
                Text("Mismo precio en \(installmentsSTR)")
                    .textStyle(.green12)

            } else if product.installments != nil {
                Text(viewModel.installmentsMessage)
                    .font(.system(size: 12))

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
