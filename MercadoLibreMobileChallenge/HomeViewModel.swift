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
    
    @Published var showSpiner = false
    @Published var requestFails = false
    @Published var homeProducts: Products? = nil
    @Published var productDetail: ProductDetail? = nil
    
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
    
    func calculatePrice(installments: String, price: Double) -> (message: String, samePrice: Bool) {
        let components = installments.components(separatedBy: "de")
        guard components.count == 2 else {
            return ("Formato inválido", false)
        }
        
        // number of installments
        let installmentsStr = components[0].trimmingCharacters(in: .whitespaces)
        let parts = installmentsStr.components(separatedBy: " ")
        
        guard let number = parts.first, let installment = Double(number) else {
            return ("Número de cuotas inválido", false)
        }
        
        // amount of installments
        let amountStr = components[1].trimmingCharacters(in: .whitespaces)
        guard let installmentsAmount = Double(amountStr) else {
            return ("Monto por cuota inválido", false)
        }
        
        let totalInstallments = installment * installmentsAmount
        
        let diference = abs(totalInstallments - price)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 3
        formatter.currencySymbol = "$"
        formatter.currencyGroupingSeparator = ""
        formatter.currencyDecimalSeparator = "."
        
        let installmentsFormatted = formatter.string(from: NSNumber(value: installmentsAmount)) ?? "$0.00"
        let installmentsMessage = "\(Int(installment)) cuotas de \(installmentsFormatted)"
        
        return (installmentsMessage, diference == 0)
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
    
    @MainActor
    func getDetailProduct() {
        Task {
            showSpiner = true
            let product = try await apiInteractor?.getProductDetail()
            if let product {
                showSpiner = false
                productDetail = product
                routeToDetail()
            } else {
                requestFails = true
            }
        }
    }
}

extension HomeViewModel {
    func routeToDetail() {
        destination?.navigate(to: .productDetailView)
    }
    
    func goBack() {
        destination?.navigateBack()
    }
    
    func routeToDeveloper() {
        destination?.navigate(to: .developerView)
    }
}
