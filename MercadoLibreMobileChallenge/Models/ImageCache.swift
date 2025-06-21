//
//  ImageCache.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 19/06/25.
//

import Foundation
import UIKit
import SwiftUI

/// `ImageCache` es una clase que proporciona un caché compartido para almacenar imágenes descargadas.
class ImageCache {
    /// Caché compartido para almacenar imágenes con URLs como clave.
    static let shared = NSCache<NSURL, UIImage>()
}

/// `CachedAsyncImage` es una vista que carga imágenes de manera asíncrona y las almacena en caché.
struct CachedAsyncImage: View {
    /// URL de la imagen que se va a cargar.
    let url: URL
    
    /// Imagen descargada, almacenada como estado.
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                // Muestra la imagen si está disponible.
                Image(uiImage: image)
                    .resizable()
            } else {
                // Muestra un indicador de progreso mientras se carga la imagen.
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    /// Carga la imagen desde el caché o realiza la descarga si no está en caché.
    private func loadImage() {
        // Verifica si la imagen ya está en caché.
        if let cachedImage = ImageCache.shared.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }
        
        // Descarga la imagen si no está en caché.
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                // Almacena la imagen en el caché.
                ImageCache.shared.setObject(uiImage, forKey: url as NSURL)
                DispatchQueue.main.async {
                    // Actualiza la imagen en la vista.
                    self.image = uiImage
                }
            }
        }.resume()
    }
}
