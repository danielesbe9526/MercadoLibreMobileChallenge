//
//  StartsView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

struct StartsView: View {
    @EnvironmentObject var colorManager: ThemeManager

    let rating: Double
    let numberOfVotes: Int
    let maxStars: Int = 5
    
    var body: some View {
        HStack(spacing: 4) {
            Text(String(format: "%.1f", rating))
                .fontWeight(.regular)
                .foregroundStyle(colorManager.fontColot.opacity(0.7))
                .font(.system(size: 14))
            
            ForEach(0..<maxStars, id: \.self) { index in
                self.starType(for: index)
                    .foregroundColor(colorManager.primaryColor)
                    .font(.system(size: 10))
            }
            
            Text("(\(numberOfVotes))")
                .fontWeight(.regular)
                .foregroundStyle(colorManager.fontColot.opacity(0.7))
                .font(.system(size: 10))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("rating del prodcuto, rating de \(Int(rating)), con \(numberOfVotes) votos")
    }
    
    func starType(for index: Int) -> Image {
        let starRating = rating - Double(index)
        if starRating >= 0.75 {
            return Image(systemName: "star.fill")
        } else if starRating >= 0.25 {
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            return Image(systemName: "star")
        }
    }
}

#Preview {
    StartsView(rating: 3.5, numberOfVotes: 12314)
        .environmentObject(ThemeManager())
}
