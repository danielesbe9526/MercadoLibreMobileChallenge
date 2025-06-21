//
//  Session.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation

/// `Session` es una clase que implementa `SessionProtocol` para manejar solicitudes de datos y decodificación.
final public class Session: SessionProtocol {
    
    /// Decodificador JSON utilizado para decodificar datos.
    let decoder = JSONDecoder()
    
    /// Realiza una solicitud a una URL y decodifica la respuesta en el tipo especificado.
    /// - Parameters:
    ///   - url: La URL desde la cual se obtendrán los datos.
    ///   - type: El tipo de datos que se espera decodificar.
    /// - Returns: Un resultado que contiene los datos decodificados o un error si falla.
    public func request<T>(url: URL, for type: T.Type) async throws -> Result<T, any Error> where T: Decodable {
        do {
            // Carga los datos desde la URL.
            let data = try Data(contentsOf: url)
            // Decodifica los datos en el tipo especificado.
            return .success(try decoder.decode(T.self, from: data))
        } catch {
            // Imprime el error y devuelve un error de decodificación.
            print("Error al cargar o decodificar: \(error)")
            return .failure(ResponseError.decoded)
        }
    }
}
