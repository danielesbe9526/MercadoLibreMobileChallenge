//
//  MLRepositoryType.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation

public protocol MLRepositoryType {
    func getHomeProducts() async throws -> Products?
    func getProductDetail() async throws -> ProductDetail?
}

public struct MLRepositoryCore: MLRepositoryType {
    weak var apiInteractor: APIInteractor?
    
    public init(apiInteractor: APIInteractor? = nil) {
        self.apiInteractor = apiInteractor
    }
    
    public func getHomeProducts() async throws -> Products? {
        let request = RepositoryRoute.homeProducts
        let result = try await apiInteractor?.loadLocalData(with: request, for: Products.self)
        
        switch result {
        case .success(let success):
            return success
        case .failure(_):
            return nil
        case .none:
            return nil
        }
    }
    
    public func getProductDetail() async throws -> ProductDetail? {
        let request = RepositoryRoute.productDetail
        let result = try await apiInteractor?.loadLocalData(with: request, for: ProductDetail.self)
        
        switch result {
        case .success(let success):
            return success
        case .failure(_):
            return nil
        case .none:
            return nil
        }
    }
}

public enum RepositoryRoute {
    case homeProducts
    case productDetail
}

public extension RepositoryRoute {
    var name: String {
        switch self {
        case .homeProducts:
            return "Home"
        case .productDetail:
            return "producto"
        }
    }
    
    var fileExtension: String {
        switch self {
        case .homeProducts, .productDetail:
            return "json"
        }
    }
}

