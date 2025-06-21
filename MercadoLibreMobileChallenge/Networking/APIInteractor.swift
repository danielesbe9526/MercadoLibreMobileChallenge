//
//  APIInteractor.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation
import Combine

/// `APIInteractor` es una clase que maneja la interacción con datos locales y remotos.
public final class APIInteractor {
    
    /// Sesión utilizada para realizar solicitudes.
    private let session: SessionProtocol
    
    /// Inicializador para `APIInteractor`.
    /// - Parameter session: Protocolo de sesión que maneja las solicitudes .
    public init(session: SessionProtocol) {
        self.session = session
    }
    
    /// Carga datos locales utilizando una ruta específica.
    /// - Parameters:
    ///   - route: La ruta del repositorio que contiene el nombre y la extensión del archivo.
    ///   - type: El tipo de datos que se espera decodificar.
    /// - Returns: Un resultado que contiene los datos decodificados o un error.
    func loadLocalData<T: Decodable>(with route: RepositoryRoute, for type: T.Type) async throws -> Result<T, Error> {
        guard let url = Bundle.main.url(forResource: route.name, withExtension: route.fileExtension) else {
            return .failure(ResponseError.invalidJSON)
        }
        
        let result = try await session.request(url: url, for: T.self)
        return result
    }
}

/// Protocolo que define la interfaz para realizar solicitudes.
public protocol SessionProtocol {
    
    /// Realiza una solicitud de red y decodifica la respuesta en el tipo especificado.
    /// - Parameters:
    ///   - url: La URL a la que se realizará la solicitud.
    ///   - type: El tipo de datos que se espera decodificar.
    /// - Returns: Un resultado que contiene los datos decodificados o un error.
    func request<T: Decodable>(url: URL, for type: T.Type) async throws -> Result<T, Error>
}

/// `ResponseError` es un enum que define los posibles errores de respuesta.
public enum ResponseError: Error {
    case unhandled
    case decoded
    case badRequest
    case unknown
    case invalidJSON
}
