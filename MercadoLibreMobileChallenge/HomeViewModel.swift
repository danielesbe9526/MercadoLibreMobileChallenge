//
//  HomeViewModel.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation

@MainActor
public class HomeViewModel: ObservableObject {
    var destination: DestinationViewModel?
    private let apiInteractor: MLRepositoryType?
    var installmentsMessage: String = ""
    
    @Published var showSpiner = false
    @Published var requestFails = false
    @Published var showSamePrice = false
    @Published var homeProducts: Products? = nil
    
    
    public init(destination: DestinationViewModel? = nil, apiInteractor: MLRepositoryType? = nil) {
        self.destination = destination
        self.apiInteractor = apiInteractor
    }
    
    // Preview Init
    public init(homeProducts: Products) {
        self.homeProducts = homeProducts
        self.destination = DestinationViewModel()
        self.apiInteractor = MLRepositoryCore()
    }
    
    func calculatePrice(installments: String, price: Double) -> String {
        let components = installments.components(separatedBy: "de")
        guard components.count == 2 else {
            return "Formato inválido"
        }
        
        // number of installments
        let installmentsStr = components[0].trimmingCharacters(in: .whitespaces)
        let parts = installmentsStr.components(separatedBy: " ")
        
        guard let number = parts.first, let installment = Double(number) else {
            return "Número de cuotas inválido"
        }
        
        // amount of installments
        let amountStr = components[1].trimmingCharacters(in: .whitespaces)
        guard let installmentsAmount = Double(amountStr) else {
            return "Monto por cuota inválido"
        }
        
        let totalInstallments = installment * installmentsAmount
        
        let diference = abs(totalInstallments - price)
        let tolerance = 0.001
        
        let installmentsFormatted = String(format: "%.3f", installmentsAmount)
        installmentsMessage = "\(Int(installment)) cuotas de $\(installmentsFormatted)"
        
        if diference <= tolerance {
            showSamePrice = true
        }
        
        return "\(installment) cuotas de $\(installmentsFormatted)"
    }
    
    @MainActor
    func getHomeProducts() {
        Task {
            showSpiner = true
            let products = try await apiInteractor?.getHomeProducts()
            if let products = products {
                showSpiner = false
                homeProducts = products
            } else {
                requestFails = true
            }
        }
    }
}

