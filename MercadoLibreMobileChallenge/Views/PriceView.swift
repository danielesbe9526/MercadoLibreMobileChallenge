//
//  PriceView.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import SwiftUI

struct PriceView: View {
    let value: Double
    let size: CGFloat
    
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text("$\(Int(value))")
                .font(.system(size: size, weight: .medium))
            
            let decimalString = String(format: "%.2f", value).split(separator: ".")[1]
            Text("." + decimalString)
                .font(.system(size: size/1.4))
                .baselineOffset(8)
        }
    }
}

#Preview {
    PriceView(value: 121234234344.542, size: 24)
}
