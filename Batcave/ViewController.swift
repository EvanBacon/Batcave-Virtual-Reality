//
//  ViewController.swift
//  Batcave
//
//  Created by Evan Bacon on 6/3/16.
//  Copyright © 2016 Brix. All rights reserved.
//
import UIKit
import GoogleMaps
import CoreMotion
import CoreLocation
let wayne = "https://www.google.com/maps/@42.762321,-83.2835739,3a,75y,255.67h,60.37t/data=!3m7!1e1!3m5!1seK9_8zTeH7oAAAQvOrBWlg!2e0!3e2!7i8000!8i4000"


extension ViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if newLocation.distanceFromLocation(oldLocation) > 10 {
            print("updateUser")
        }
        print(newLocation.distanceFromLocation(oldLocation))
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.Authorized {
        //        self.view.addSubview(GMSMapView(frame: self.view.frame))
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        panoView = GMSPanoramaView(frame: CGRectZero)
        panoView.streetNamesHidden = true
        panoView.orientationGestures = false
        self.view = panoView
        panoView.moveToPanoramaID("106KguVcdQ0AAAQvOrBWlw")
        //        panoView.moveNearCoordinate(CLLocationCoordinate2DMake(42.76228,-83.283345))
        panoView.delegate = self
        
        
        CLLocationManager().requestAlwaysAuthorization()
        self.manager.deviceMotionUpdateInterval  = 0.2
        self.manager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler: {(motionData: CMDeviceMotion?, NSError) -> Void in self.outputRPY(motionData!)
            if (NSError != nil){
                print("\(NSError)")
            }
        })
        }
        
    }
}

class ViewController: UIViewController, GMSPanoramaViewDelegate {
    var manager         = CMMotionManager()
    var locationManager         = CLLocationManager()

    func outputRPY(data: CMDeviceMotion){
        let rpyattitude = manager.deviceMotion!.attitude
        var roll    = rpyattitude.roll * (180.0 / M_PI)
        var pitch   = rpyattitude.pitch * (180.0 / M_PI)
        var yaw     = rpyattitude.yaw * (180.0 / M_PI)
        //        rollLabel.text  = String(format: "%.2f°", roll)
        //        pitchLabel.text = String(format: "%.2f°", pitch)
        //        yawLabel.text   = String(format: "%.2f°", yaw)
        
        panoView.camera = GMSPanoramaCamera(heading: -yaw, pitch: roll - 90, zoom: 1)
        
    }
    var panoView:GMSPanoramaView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
      
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation();




    }
    
    // MARK: - GMSPanoramaViewDelegate
    func panoramaView(view: GMSPanoramaView, error: NSError, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
        print("Moving near coordinate (\(coordinate.latitude),\(coordinate.longitude) error: \(error.localizedDescription)")
    }
    
    func panoramaView(view: GMSPanoramaView, error: NSError, onMoveToPanoramaID panoramaID: String) {
        print("Moving to PanoID \(panoramaID) error: \(error.localizedDescription)")
    }
    
    func panoramaView(view: GMSPanoramaView, didMoveToPanorama panorama: GMSPanorama?) {
        print("Moved to panoramaID: \(panorama!.panoramaID) " +
            "coordinates: (\(panorama!.coordinate.latitude),\(panorama!.coordinate.longitude))")
    }
}

