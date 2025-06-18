//
//  Session.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation

final public class Session: SessionProtocol {
    let decoder = JSONDecoder()
    
    public func request<T>(url: URL, for type: T.Type) async throws -> Result<T, any Error> where T : Decodable {
        do {
            let data = try Data(contentsOf: url)
            return .success(try decoder.decode(T.self, from: data))
        } catch {
            print("Error al cargar o decodificar: \(error)")
            return .failure(ResponseError.decoded)
        }
    }
}
