//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Shimaa on 08/12/2022.
//

import Foundation
import MapKit
import Combine

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    public static let shared = LocationManager()
    private let locationMgr = CLLocationManager()
    var currentCity = PassthroughSubject<String, Never>()
    
    private override init() {
        super.init()
        self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest
        self.locationMgr.distanceFilter = kCLLocationAccuracyThreeKilometers
        self.locationMgr.pausesLocationUpdatesAutomatically = true
        locationMgr.delegate = self
        locationMgr.requestWhenInUseAuthorization()
    }
    
    
    public func enableLocation(){
        switch locationMgr.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.locationMgr.startUpdatingLocation()
            default:
            return
        }
    }
    
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationMgr.stopUpdatingLocation()
        if let location = locations.first {
            getAddressFromLatAndLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
        }
    }
    
    public func getAddressFromLatAndLng(lat: CLLocationDegrees, lng: CLLocationDegrees) {
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: lat, longitude: lng)

        ceo.reverseGeocodeLocation(loc, preferredLocale: Locale(identifier: "en_US"), completionHandler: { (placemarks, error) in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            
            let placeMarks = placemarks! as [CLPlacemark]
            
            if placeMarks.count > 0, let placeMark = placemarks?[0] {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.currentCity.send(placeMark.locality ?? "")
                }
            }
        })
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.locationMgr.startUpdatingLocation()
        }
    }
}
