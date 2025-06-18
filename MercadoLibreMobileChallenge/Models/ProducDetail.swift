//
//  ProducDetail.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation

// MARK: - ProductDetail
public struct ProductDetail: Codable, Sendable {
    let id: String?
    let name: String?
    let store: String?
    let brand: String?
    let seller: String?
    let rating: Double?
    let numReviews: Int?
    let originalPrice: Double?
    let discountedPrice: Double?
    let discountPercentage: Double?
    let stock: Int?
    let installments: Installments?
    let shipping: String?
    let images: [String]?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name = "product_name"
        case store, brand, seller, rating
        case numReviews = "num_reviews"
        case originalPrice = "original_price"
        case discountedPrice = "discounted_price"
        case discountPercentage = "discount_percentage"
        case stock, installments, shipping, images, description
    }
    
    var isAppleSeller: Bool {
        return brand == "Apple"
    }
}

// MARK: - Installments
public struct Installments: Codable, Sendable {
    let value: String?
    let alternative: String?
}
