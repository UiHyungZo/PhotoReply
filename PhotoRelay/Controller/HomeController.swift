//
//  HomeController.swift
//  PhotoRelay
//
//  Created by Mac on 2022/01/09.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase
import FirebaseFirestore
import GoogleMapsUtils


class HomeController: UIViewController {

    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var preciseLocationZoomLevel: Float = 15.0
    var approximateLocationZoomLevel: Float = 10.0
    var marker:[GMSMarker] = []
    var apiModel = ApiModel()
    var handle : AuthStateDidChangeListenerHandle?//로그인 정보
    var userEmail:String?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        handle = Auth.auth().addStateDidChangeListener({auth, user in
            print("handle closure")
            if user != nil{
                self.userEmail = user?.email
                print("email : \(self.userEmail)")
//                self.apiModel.selectMarker(userEmail: self.userEmail!)
                print("apiModel user != 문")
                //select
                self.db.collection(self.userEmail!).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        
                    } else {
                        
                        for document in querySnapshot!.documents {
//                            print("\(document.documentID) => \(document.data())")
//                            print(document.get("userId"))
//                            print("userId 값")
                            let loc2 = CLLocationCoordinate2D(latitude: document.get("latitude") as! CLLocationDegrees , longitude: document.get("longitude") as! CLLocationDegrees)
                            self.marker.append(GMSMarker.init(position: loc2))
                            
                        }
                        
                        for i in self.marker{
                            i.map = self.mapView
                        }
                        
                        
                    }
                }
            }else{
                print("잘못된 정보")
            }
        })
        
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self

        placesClient = GMSPlacesClient.shared()
        
        // A default location to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: -33.869405, longitude: 151.199)

        // Create a map.
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true

        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        
        
        print("userEmail type : \(type(of: self.userEmail))")
        print("userEmail : \(self.userEmail)")
        
        
        
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        view.reloadInputViews()
//        mapView.reloadInputViews()
    }
    

}

// Delegates to handle events for the location manager.
extension HomeController: CLLocationManagerDelegate,GMSMapViewDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        print("locationManager touch")
       
        
        
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Check accuracy authorization
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        
        // Handle authorization status
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        @unknown default:
            fatalError()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("didLongPressAt")
        print(coordinate.latitude)
        print(coordinate.longitude)
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("didTap 호출")
        mapView.animate(toLocation: marker.position)
          // check if a cluster icon was tapped
          if marker.userData is GMUCluster {
            // zoom in on tapped cluster
            mapView.animate(toZoom: mapView.camera.zoom + 1)
            NSLog("Did tap cluster")
            return true
          }

          NSLog("Did tap a normal marker")
          return false
        
    }
}
