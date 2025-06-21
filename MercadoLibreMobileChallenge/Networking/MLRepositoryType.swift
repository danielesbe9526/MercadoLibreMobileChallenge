//
//  MLRepositoryType.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation

/// Protocolo `MLRepositoryType` que define métodos para obtener productos y detalles de productos.
public protocol MLRepositoryType {
    
    /// Obtiene los productos de inicio.
    /// - Returns: Una lista de productos o `nil` si ocurre un error.
    func getHomeProducts() async throws -> Products?
    
    /// Obtiene los detalles de un producto.
    /// - Returns: Detalles del producto o `nil` si ocurre un error.
    func getProductDetail() async throws -> ProductDetail?
}

/// `MLRepositoryCore` es una estructura que implementa `MLRepositoryType` para manejar datos de productos.
public struct MLRepositoryCore: MLRepositoryType {
    
    /// Interactor de API utilizado para cargar datos.
    weak var apiInteractor: APIInteractor?
    
    /// Inicializador para `MLRepositoryCore`.
    /// - Parameter apiInteractor: Interactor de API opcional para manejar solicitudes.
    public init(apiInteractor: APIInteractor? = nil) {
        self.apiInteractor = apiInteractor
    }
    
    /// Obtiene los productos de inicio.
    /// - Returns: Una lista de productos o `nil` si ocurre un error.
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
    
    /// Obtiene los detalles de un producto.
    /// - Returns: Detalles del producto o `nil` si ocurre un error.
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

/// `RepositoryRoute` enum que define las rutas para cargar datos locales.
public enum RepositoryRoute {
    case homeProducts
    case productDetail
}

public extension RepositoryRoute {
    
    /// Nombre del archivo para la ruta.
    var name: String {
        switch self {
        case .homeProducts:
            return "Home"
        case .productDetail:
            return "producto"
        }
    }
    
    /// Extensión del archivo para la ruta.
    var fileExtension: String {
        switch self {
        case .homeProducts, .productDetail:
            return "json"
        }
    }
}
