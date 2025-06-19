//
//  CardHView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

struct CardHView: View {
    var product: Product
    @ObservedObject var viewModel: HomeViewModel
    @State var installmentsSTR: String = ""

    var body: some View {
        VStack(spacing: 15) {
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
                    .foregroundStyle(.gray.opacity(0.2))
                    .frame(maxHeight: 200)
                    .scaledToFit()

            case .success(let image):
                image
                    .resizable()
                    .frame(maxHeight: 200)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            
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
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading) {
                if let brand = product.brand {
                    Text(brand.uppercased())
                        .textStyle(.brand)
                }
                
                if let name = product.name {
                    Text(product.isAppleSeller ? name + " - " + "Distribuidor Autorizado" : name)
                        .textStyle(.tittle)
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
                prices(originalPrice)
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
    
    @ViewBuilder
    func prices(_ originalPrice: Double) -> some View {
        VStack(alignment: .leading) {
            if let discountedPrice = product.discountedPrice {
                PriceView(value: discountedPrice, size: 14)
                    .foregroundStyle(.gray.opacity(0.7))
                
                HStack {
                    PriceView(value: originalPrice, size: 18)
                    let discountPercentage = String(format: "%.1f", product.discountPercentage ?? 0)
                    Text("\(discountPercentage)%OFF")
                        .textStyle(.discount)
                }
            } else {
                PriceView(value: originalPrice, size: 18)
            }
        }
    }
}

#Preview {
    CardHView(product: Product(
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
    .frame(width: 180)
}
