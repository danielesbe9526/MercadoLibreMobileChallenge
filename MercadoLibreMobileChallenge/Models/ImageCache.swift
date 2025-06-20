//
//  ImageCache.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 19/06/25.
//

import Foundation
import UIKit
import SwiftUI

class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}

struct CachedAsyncImage: View {
    let url: URL
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        if let cachedImage = ImageCache.shared.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let uiImage = UIImage(data: data) {
                ImageCache.shared.setObject(uiImage, forKey: url as NSURL)
                DispatchQueue.main.async {
                    self.image = uiImage
                }
            }
        }.resume()
    }
}
