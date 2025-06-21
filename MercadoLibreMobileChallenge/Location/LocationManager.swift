//
//  LocationManager.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 19/06/25.
//

import CoreLocation

/// `LocationManager` es una clase que gestiona la ubicación del usuario y obtiene la dirección correspondiente.
/// Conforma a `NSObject` y `ObservableObject` para integrarse con SwiftUI y el sistema de delegación de Core Location.
class LocationManager: NSObject, ObservableObject {
    
    /// Instancia del administrador de ubicación.
    private let locationManager = CLLocationManager()
    
    /// Geocodificador para convertir coordenadas en direcciones.
    private let geocoder = CLGeocoder()
    
    /// Coordenadas actuales del usuario.
    @Published var userCoordinate: CLLocationCoordinate2D?
    
    /// Información de la dirección actual del usuario.
    @Published var placemark: CLPlacemark?
    
    /// Mensaje de error en caso de fallos.
    @Published var errorMessage: String?
    
    /// Último tiempo en que se realizó una geocodificación.
    private var lastGeocodeTime: Date?
    
    /// Intervalo mínimo entre solicitudes de geocodificación.
    private let minIntervalBetweenRequests: TimeInterval = 10

    /// Inicializador que configura el administrador de ubicación.
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorization()
    }
    
    /// Verifica el estado de autorización para el uso de la ubicación.
    private func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            errorMessage = "Permiso de ubicación denegado. Por favor, habilítalo en Configuración."
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            errorMessage = "Estado de autorización desconocido."
        }
    }
    
    /// Obtiene la dirección a partir de una ubicación.
    /// - Parameter location: La ubicación de la cual se quiere obtener la dirección.
    private func fetchAddress(from location: CLLocation) {
        let now = Date()
        if let lastRequest = lastGeocodeTime, now.timeIntervalSince(lastRequest) < minIntervalBetweenRequests {
            return
        }
        
        lastGeocodeTime = now
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Error al obtener la dirección: \(error.localizedDescription)"
                    return
                }
                if let placemark = placemarks?.first {
                    self?.placemark = placemark
                } else {
                    self?.errorMessage = "No se encontró ninguna dirección para esta ubicación."
                }
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    /// Maneja cambios en el estado de autorización del administrador de ubicación.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .restricted, .denied:
            errorMessage = "Permiso de ubicación denegado."
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            errorMessage = "Estado de autorización desconocido."
        }
    }

    /// Maneja actualizaciones de la ubicación del usuario.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userCoordinate = location.coordinate
            self.fetchAddress(from: location)
        }
    }

    /// Maneja errores al intentar obtener la ubicación.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Error al obtener la ubicación: \(error.localizedDescription)"
        }
    }
}

extension CLPlacemark {
    
    /// Proporciona una dirección compacta a partir de un `CLPlacemark`.
    var compactAddress: String? {
        [thoroughfare, locality, postalCode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
