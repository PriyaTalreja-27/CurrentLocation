//
//  WhereAmIViewController.swift
//  CurrentLocation
//
//  Created by Priya Talreja on 01/06/17.
//  Copyright © 2017 Priya Talreja. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class WhereAmIViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var manager: CLLocationManager!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        manager = CLLocationManager()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let myLocation : CLLocation = locations[0]
        let myLongitude: CLLocationDegrees = myLocation.coordinate.longitude
        let myLatitude : CLLocationDegrees = myLocation.coordinate.latitude
        let myDeltalat : CLLocationDegrees = 0.01
        let myDeltalong : CLLocationDegrees = 0.01
        let mySpan:MKCoordinateSpan = MKCoordinateSpanMake(myDeltalat, myDeltalong)
        let myCurrentLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLatitude, myLongitude)
        let myRegion:MKCoordinateRegion = MKCoordinateRegionMake(myCurrentLocation, mySpan)
        mapView.setRegion(myRegion, animated: true)
        
        manager.stopUpdatingLocation()
        
        let mylocation = MKPointAnnotation()
        mylocation.coordinate = myCurrentLocation
        mylocation.title = "Here yu are!"
        mapView.addAnnotation(mylocation)
        
        CLGeocoder().reverseGeocodeLocation(myLocation, completionHandler: {(placemarks,error) in
            if ((error) != nil)
            {
                print("Errror")
            }
            else
            {
                let p = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark!))
                var subthoroughFare:String = ""
                var thoroughFare:String = ""
                var subLocality:String = ""
                var subAdministrativeArea:String = ""
                var postalCode:String = ""
                var country:String = ""
                
                if(p.subThoroughfare != nil)
                {
                    subthoroughFare = p.subThoroughfare!
                }
                if((p.thoroughfare) != nil)
                {
                    thoroughFare = (p.thoroughfare)!
                }
                if((p.subLocality) != nil)
                {
                    subLocality = (p.subLocality)!
                }
                if((p.subAdministrativeArea) != nil)
                {
                    subAdministrativeArea = (p.subAdministrativeArea)!
                }
                if((p.postalCode) != nil)
                {
                    postalCode = (p.postalCode)!
                }
                if((p.country) != nil)
                {
                    country = (p.country)!
                }
                
                self.address.text = "\(subthoroughFare) \(thoroughFare)\n\(subLocality)\n\(subAdministrativeArea) \(postalCode)\n\(country)"
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways
        {
            manager.stopUpdatingLocation()
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print(error.debugDescription)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
