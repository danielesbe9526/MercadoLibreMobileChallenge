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
        .padding(.horizontal, 8)
        .onAppear {
            if let installments = product.installments,
               let price = product.originalPrice {
                installmentsSTR = viewModel.calculatePrice(installments: installments, price: price)
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
                    .frame(maxWidth: 120)
                    .scaledToFit()
                    .foregroundStyle(.gray.opacity(0.2))
                
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 120)
                    .scaledToFit()
            
            @unknown default:
                Image(systemName: "photo.fill")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(.gray.opacity(0.2))
                    .frame(maxWidth: 100)
            }
        }
    }
    
    @ViewBuilder
    var productDescription: some View {
        VStack(alignment: .leading, spacing: 15) {
            if let store = product.store {
                Text(store.uppercased())
                    .font(.system(size: 12))
                    .padding(3)
                    .fontWeight(.thin)
                    .background(.black)
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading) {
                if let brand = product.brand {
                    Text(brand.uppercased())
                        .font(.system(size: 14))
                        .foregroundStyle(.font)
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
                HStack {
                    StartsView(rating: rating, numberOfVotes: product.numReviews ?? 0)

                }
            }
            
            if let originalPrice = product.originalPrice {
                
                VStack(alignment: .leading) {
                    if let discountedPrice = product.discountedPrice {
                        PriceView(value: discountedPrice, size: 14)
                            .foregroundStyle(.gray.opacity(0.6))
                        
                        HStack {
                            PriceView(value: originalPrice, size: 20)
                            let discountPercentage = String(format: "%.1f", product.discountPercentage ?? 0)
                            Text("\(discountPercentage)%OFF")
                                .foregroundStyle(.green)
                                .fontWeight(.light)
                                .font(.system(size: 14))
                        }
                    } else {
                        PriceView(value: originalPrice, size: 18)
                    }
                }
            }
            
            if viewModel.showSamePrice {
                Text("Mismo precio en \(installmentsSTR)")
                    .foregroundStyle(.green)
                    .font(.system(size: 12))

            } else if product.installments != nil {
                Text(viewModel.installmentsMessage)
                    .font(.system(size: 12))

            }
           
            if let shipping = product.shipping {
                Text(shipping)
                    .foregroundStyle(.green)
                    .font(.system(size: 12))
            }
            Spacer()
        }
    }
}

#Preview {
    CardVView(product:
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
                ), viewModel: HomeViewModel(destination: nil))
}


