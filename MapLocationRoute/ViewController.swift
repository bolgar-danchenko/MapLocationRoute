//
//  ViewController.swift
//  MapLocationRoot
//
//  Created by Konstantin Bolgar-Danchenko on 03.12.2022.
//

import UIKit
import MapKit
import CoreLocation
import JGProgressHUD

class ViewController: UIViewController {

    let loadingIndicator = JGProgressHUD()
    
    private var userLocation: CLLocation?
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        return locationManager
    }()
    
    // MARK: - Subviews
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var routeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .link
        button.setTitle("GO TO PARIS", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray4, for: .highlighted)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(routeToParis), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var removeRouteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemRed
        button.setTitle("Remove Route", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray4, for: .highlighted)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(removeRoute), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var removePinsButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "mappin.slash.circle"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "mappin.slash.circle.fill"), for: .highlighted)
        button.tintColor = .red
        button.addTarget(self, action: #selector(removePins), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupSubviews()
        setupConstraints()
        
        findUserLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocation), name: NSNotification.Name("did-update-location"), object: nil)
        
        loadingIndicator.textLabel.text = "Please wait..."
    }
    
    // MARK: - Layout
    
    private func setupSubviews() {
        view.addSubview(mapView)
        view.addSubview(removeRouteButton)
        view.addSubview(removePinsButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            removeRouteButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            removeRouteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            removeRouteButton.heightAnchor.constraint(equalToConstant: 40),
            removeRouteButton.widthAnchor.constraint(equalToConstant: 120),
            
            removePinsButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            removePinsButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            removePinsButton.heightAnchor.constraint(equalToConstant: 40),
            removePinsButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Map and Location
    
    private func findUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    @objc private func didUpdateLocation() {
        setupMap()
        
        view.addSubview(routeButton)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            routeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            routeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            routeButton.heightAnchor.constraint(equalToConstant: 40),
            routeButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupMap() {
        guard let initialLocation = userLocation else {
            return
        }
        let region = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: 100_000, longitudinalMeters: 100_000)
        
        mapView.setCenter(initialLocation.coordinate, animated: true)
        mapView.setRegion(region, animated: false)
        
        mapView.addAnnotations(VisitedPlaces.make())
        
        // Использование свойств класса MKMapView для конфигурации вида карты
        mapView.mapType = .mutedStandard
        mapView.showsScale = true
        mapView.preferredConfiguration.elevationStyle = .realistic
        mapView.selectableMapFeatures = .pointsOfInterest
        mapView.isRotateEnabled = false
        
        mapView.delegate = self
    }
    
    // MARK: - Route
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            
            guard let unwrappedResponse = response else {
                self.loadingIndicator.dismiss(animated: true)
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let route = unwrappedResponse.routes.first {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                self.loadingIndicator.dismiss(animated: true)
                self.removeRouteButton.isHidden = false
            }
        }
    }
    
    @objc private func routeToParis() {
        loadingIndicator.show(in: self.view, animated: true)
        routeButton.isHidden = true
        
       let londonLocation = CLLocationCoordinate2D(latitude: 51.509865, longitude: -0.118092)
        let parisLocation = CLLocationCoordinate2D(latitude: 48.864716, longitude: 2.349014)
        
        showRouteOnMap(pickupCoordinate: londonLocation, destinationCoordinate: parisLocation)
    }
    
    @objc private func removeRoute() {
        mapView.removeOverlays(mapView.overlays)
        removeRouteButton.isHidden = true
        routeButton.isHidden = false
        
        guard let coordinates = userLocation?.coordinate as? CLLocationCoordinate2D else { return }
        mapView.setCenter(coordinates, animated: true)
    }
    
    @objc private func removePins() {
        mapView.removeAnnotations(mapView.annotations)
    }
}

// MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .notDetermined:
            findUserLocation()
        case .restricted, .denied:
            print("Location is forbidden")
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            userLocation = location
    
            NotificationCenter.default.post(name: NSNotification.Name("did-update-location"), object: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error occurred: \(error.localizedDescription)")
    }
}

// MARK: - MKMapViewDelegate Extension

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.link
        renderer.lineWidth = 5.0
        return renderer
    }
}
