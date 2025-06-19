//
//  LocationManager.swift
//  MercadoLibreMobileChallenge
//
//  Created by Daniel Beltran on 19/06/25.
//

import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var userCoordinate: CLLocationCoordinate2D?
    @Published var placemark: CLPlacemark?
    @Published var errorMessage: String?

    private var lastGeocodeTime: Date?
    private let minIntervalBetweenRequests: TimeInterval = 10

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        checkAuthorization()
    }
    
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userCoordinate = location.coordinate
            self.fetchAddress(from: location)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Error al obtener la ubicación: \(error.localizedDescription)"
        }
    }
}


extension CLPlacemark {
    var compactAddress: String? {
        [thoroughfare, locality, postalCode]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
