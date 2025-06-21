//
//  HomeViewModel.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 18/06/25.
//

import Foundation

/// `HomeViewModel` es una clase que gestiona la lógica de negocio para la vista principal.
@MainActor
public class HomeViewModel: ObservableObject {
    
    /// ViewModel de destino para manejar la navegación.
    var destination: DestinationViewModel?
    
    /// Interactor de API para manejar las solicitudes de datos.
    private let apiInteractor: MLRepositoryType?
    
    /// Mensaje sobre las cuotas.
    var installmentsMessage: String = ""
    
    /// Indica si se debe mostrar el spinner de carga.
    @Published var showSpiner = false
    
    /// Indica si la solicitud de datos ha fallado.
    @Published var requestFails = false
    
    /// Indica si el precio es el mismo.
    @Published var showSamePrice = false
    
    /// Productos obtenidos para la vista principal.
    @Published var homeProducts: Products? = nil
    
    /// Detalles del producto actual.
    @Published var productDetail: ProductDetail? = nil
    
    /// Inicializador principal para `HomeViewModel`.
    /// - Parameters:
    ///   - destination: ViewModel de destino opcional.
    ///   - apiInteractor: Interactor de API opcional.
    public init(destination: DestinationViewModel? = nil, apiInteractor: MLRepositoryType? = nil) {
        self.destination = destination
        self.apiInteractor = apiInteractor
    }
    
    /// Inicializador para vista previa.
    /// - Parameter homeProducts: Productos para inicializar.
    public init(homeProducts: Products) {
        self.homeProducts = homeProducts
        self.destination = DestinationViewModel()
        self.apiInteractor = MLRepositoryCore()
    }
    
    /// Calcula el precio total basado en las cuotas.
    /// - Parameters:
    ///   - installments: Texto de cuotas.
    ///   - price: Precio total.
    /// - Returns: Texto con el formato de cuotas.
    func calculatePrice(installments: String, price: Double) -> String {
        let components = installments.components(separatedBy: "de")
        guard components.count == 2 else {
            return "Formato inválido"
        }
        
        let installmentsStr = components[0].trimmingCharacters(in: .whitespaces)
        let parts = installmentsStr.components(separatedBy: " ")
        
        guard let number = parts.first, let installment = Double(number) else {
            return "Número de cuotas inválido"
        }
        
        let amountStr = components[1].trimmingCharacters(in: .whitespaces)
        guard let installmentsAmount = Double(amountStr) else {
            return "Monto por cuota inválido"
        }
        
        let totalInstallments = installment * installmentsAmount
        let diference = abs(totalInstallments - price)
        let tolerance = 0.001
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 3
        
        let installmentsFormatted = formatter.string(from: NSNumber(value: installmentsAmount)) ?? "$0.00"
        installmentsMessage = "\(Int(installment)) cuotas de \(installmentsFormatted)"
        
        if diference <= tolerance {
            showSamePrice = true
        }
        
        return "\(Int(installment)) cuotas de \(installmentsFormatted)"
    }
    
    /// Obtiene los productos para la vista principal.
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
    
    /// Obtiene los detalles del producto seleccionado.
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
    
    /// Navega a la vista de detalles del producto.
    func routeToDetail() {
        destination?.navigate(to: .productDetailView)
    }
    
    /// Navega atrás en la pila de navegación.
    func goBack() {
        destination?.navigateBack()
    }
    
    /// Navega a la vista de desarrollador.
    func routeToDeveloper() {
        destination?.navigate(to: .developerView)
    }
}
