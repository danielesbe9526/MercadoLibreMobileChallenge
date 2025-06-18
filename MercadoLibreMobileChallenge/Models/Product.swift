//
//  Product.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation

// MARK: - Product
public struct Product: Codable, Sendable, Identifiable {
    public let id: String
    let name: String?
    let store: String?
    let brand: String?
    let seller: String?
    let rating: Double?
    let numReviews: Int?
    let originalPrice: Double?
    let discountedPrice: Double?
    let discountPercentage: Double?
    let installments: String?
    let shipping: String?
    let images: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case name = "product_name"
        case store, brand, seller, rating
        case numReviews = "num_reviews"
        case originalPrice = "original_price"
        case discountedPrice = "discounted_price"
        case discountPercentage = "discount_percentage"
        case installments, shipping, images
    }
    
    var isAppleSeller: Bool {
        return brand == "Apple"
    }
}

public typealias Products = [Product]
