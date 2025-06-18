//
//  APIInteractor.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation

import Foundation
import Combine

public final class APIInteractor {
    private let session: SessionProtocol
    
    public init (session: SessionProtocol) {
        self.session = session
    }
    
    func loadLocalData<T: Decodable>(with route: RepositoryRoute, for type: T.Type) async throws -> Result<T, Error> {
        guard let url = Bundle.main.url(forResource: route.name, withExtension: route.fileExtension) else {
            return .failure(ResponseError.invalidJSON)
        }
 
        let result = try await session.request(url: url, for: T.self)
        return result
    }
}


public protocol SessionProtocol {
    func request<T: Decodable>(url: URL, for type: T.Type) async throws -> Result<T, Error>
}

public enum ResponseError: Error {
    case unhandled
    case decoded
    case badRequest
    case unknown
    case invalidJSON
}
