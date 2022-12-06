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

class MapViewController: UIViewController {
    
    let allStrings = AllStrings()
    
    // MARK: - Subviews
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var routeButton: AdaptableSizeButton = {
        let button = AdaptableSizeButton()
        button.backgroundColor = .link
        button.setTitle(allStrings.createRouteButtonTittle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray4, for: .highlighted)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(createRoute), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var removeRouteButton: AdaptableSizeButton = {
        let button = AdaptableSizeButton()
        button.backgroundColor = .systemRed
        button.setTitle(allStrings.removeRouteButtonTittle, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray4, for: .highlighted)
        button.titleLabel?.textAlignment = .center
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
    
    private lazy var locationDeniedLabel: UILabel = {
        let label = UILabel()
        label.text = allStrings.locationDeniedDescr
        label.font = .systemFont(ofSize: 32, weight: .medium)
        label.textColor = .systemGray4
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .right
        label.backgroundColor = .systemGray
        label.sizeToFit()
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        setupConstraints()
        
        requestLocation()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        mapView.delegate = self
    }
    
    // MARK: - Layout
    
    private func setupSubviews() {
        view.addSubview(mapView)
        mapView.frame = view.bounds
        view.addSubview(removeRouteButton)
        view.addSubview(removePinsButton)
        view.addSubview(distanceLabel)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            removeRouteButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            removeRouteButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            removeRouteButton.heightAnchor.constraint(equalToConstant: 40),
            
            removePinsButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            removePinsButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            removePinsButton.heightAnchor.constraint(equalToConstant: 40),
            removePinsButton.widthAnchor.constraint(equalToConstant: 40),
            
            distanceLabel.topAnchor.constraint(equalTo: removeRouteButton.bottomAnchor, constant: 10),
            distanceLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Location
    
    private func requestLocation() {
        
        IndicatorModel.loadingIndicator.show(in: self.view, animated: true)
        CoreLocationManager.shared.findUserLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateLocation), name: NSNotification.Name("did-update-location"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(accessDenied), name: NSNotification.Name("access-denied"), object: nil)
    }
    
    @objc private func didUpdateLocation() {
        
        IndicatorModel.loadingIndicator.dismiss(animated: true)
        
        setupMap()
        
        view.addSubview(routeButton)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            routeButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            routeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            routeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func accessDenied() {
        IndicatorModel.loadingIndicator.dismiss(animated: true)
        mapView.isHidden = true
        removePinsButton.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view.addSubview(self.locationDeniedLabel)
            
            let safeArea = self.view.safeAreaLayoutGuide
            
            NSLayoutConstraint.activate([
                self.locationDeniedLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
                self.locationDeniedLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
                self.locationDeniedLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
                self.locationDeniedLabel.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20)
            ])
        }
    }
    
    // MARK: - Map
    
    private func setupMap() {
        
        guard let initialLocation = CoreLocationManager.shared.userLocation else {
            AlertModel.shared.showAlert(title: allStrings.errorAlertTitle, descr: allStrings.locationErrorDescr, buttonText: allStrings.okButtonLabel)
            return
        }
        let region = MKCoordinateRegion(center: initialLocation.coordinate, latitudinalMeters: 100_000, longitudinalMeters: 100_000)
        
        mapView.setCenter(initialLocation.coordinate, animated: true)
        mapView.setRegion(region, animated: false)
        
//        mapView.addAnnotations(VisitedPlaces.make())
        addPinsFromArray()
        
        // Использование свойств класса MKMapView для конфигурации вида карты
        mapView.mapType = .standard
        mapView.showsScale = true
        mapView.preferredConfiguration.elevationStyle = .realistic
        mapView.selectableMapFeatures = .pointsOfInterest
        mapView.isRotateEnabled = false
    }
    
    // MARK: - Pins
    
    func addPinsFromArray() {
        let pinArray = VisitedPlaces.shared.make()
        for customPin in pinArray {
            let pin = MKPointAnnotation()
            pin.coordinate = customPin.coordinate
            pin.title = customPin.title
            pin.subtitle = customPin.info
            mapView.addAnnotation(pin)
        }
    }
    
    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        let touchPoint = sender.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = newCoordinates
        
        let alert = UIAlertController(title: allStrings.addPinTitle, message: allStrings.addPinDescr, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = self.allStrings.addPinPlaceholder
        }
        alert.addAction(UIAlertAction(title: allStrings.cancelButtonLabel, style: .cancel))
        alert.addAction(UIAlertAction(title: allStrings.okButtonLabel, style: .default) { _ in
            if let textFields = alert.textFields,
               let tf = textFields.first,
               let title = tf.text {
                annotation.title = title
                self.mapView.addAnnotation(annotation)
            } else {
                AlertModel.shared.showAlert(title: self.allStrings.errorAlertTitle, descr: self.allStrings.pinAddingErrorDescr, buttonText: self.allStrings.okButtonLabel)
            }
        })
        navigationController?.present(alert, animated: true)
    }
    
    @objc private func removePins() {
        mapView.removeAnnotations(mapView.annotations)
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
                IndicatorModel.loadingIndicator.dismiss(animated: true)
                AlertModel.shared.showAlert(title: self.allStrings.errorAlertTitle, descr: self.allStrings.routeUnavailableDescr, buttonText: self.allStrings.okButtonLabel)
                print(error?.localizedDescription ?? "Unknown error")
                IndicatorModel.loadingIndicator.dismiss(animated: true)
                self.routeButton.isHidden = false
                return
            }
            
            if let route = unwrappedResponse.routes.first {
                DispatchQueue.main.async {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                    IndicatorModel.loadingIndicator.dismiss(animated: true)
                    self.removeRouteButton.isHidden = false
                    
                    self.distanceLabel.text = CoreLocationManager.shared.getDistance(route: route)
                    self.distanceLabel.isHidden = false
                }
            }
        }
    }
    
    @objc private func createRoute() {
        
        IndicatorModel.loadingIndicator.show(in: self.view, animated: true)
        routeButton.isHidden = true
        
        guard let firstLocation = CoreLocationManager.shared.userLocation?.coordinate else {
            AlertModel.shared.showAlert(title: self.allStrings.errorAlertTitle, descr: self.allStrings.locationErrorDescr, buttonText: self.allStrings.okButtonLabel)
            IndicatorModel.loadingIndicator.dismiss(animated: true)
            routeButton.isHidden = false
            return
        }
        
        let alert = UIAlertController(title: allStrings.routeAlertTitle, message: "", preferredStyle: .alert)
        alert.addTextField()
        alert.textFields?.first?.placeholder = allStrings.routeAlertPlaceholder
        alert.addAction(UIAlertAction(title: allStrings.routeAlertOkButton, style: .default) { _ in
            
            guard let address = alert.textFields?.first?.text, !address.isEmpty else {
                AlertModel.shared.showAlert(title: self.allStrings.errorAlertTitle, descr: self.allStrings.emptyLocationText, buttonText: self.allStrings.okButtonLabel)
                IndicatorModel.loadingIndicator.dismiss(animated: true)
                self.routeButton.isHidden = false
                return
            }
            
            CoreLocationManager.shared.getLocation(from: address) { location in
                
                guard let secondLocation = location else {
                    AlertModel.shared.showAlert(title: self.allStrings.errorAlertTitle, descr: self.allStrings.locationErrorDescr, buttonText: self.allStrings.okButtonLabel)
                    IndicatorModel.loadingIndicator.dismiss(animated: true)
                    self.routeButton.isHidden = false
                    return
                }
        
                self.showRouteOnMap(pickupCoordinate: firstLocation, destinationCoordinate: secondLocation)
            }
        })
        self.present(alert, animated: true)
    }
    
    @objc private func removeRoute() {
        mapView.removeOverlays(mapView.overlays)
        removeRouteButton.isHidden = true
        routeButton.isHidden = false
        distanceLabel.text = ""
        distanceLabel.isHidden = true
        
        guard let coordinates = CoreLocationManager.shared.userLocation?.coordinate as? CLLocationCoordinate2D else {
            AlertModel.shared.showAlert(title: self.allStrings.errorAlertTitle, descr: self.allStrings.locationErrorDescr, buttonText: self.allStrings.okButtonLabel)
            return }
        mapView.setCenter(coordinates, animated: true)
    }
}

// MARK: - MKMapViewDelegate Extension

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.link
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(systemName: "flag.fill")
        return annotationView
    }
}
