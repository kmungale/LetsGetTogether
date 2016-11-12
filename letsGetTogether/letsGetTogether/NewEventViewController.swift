//
//  NewEventViewController.swift
//  iOS-project-16
//
//  Created by macbook_user on 10/29/16.
//  Copyright © 2016 Kaustubh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseDatabase



class NewEventViewController: UIViewController, CLLocationManagerDelegate {

    
    var ref: FIRDatabaseReference!

    var dataStorage: UserDefaults?
    var location: CLLocationManager?
    var x =  [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataStorage = UserDefaults.standard
        
        location = CLLocationManager()
        location?.delegate = self
        //location?.desiredAccuracy = kCLLocationAccuracyBest
        location?.requestWhenInUseAuthorization()
        //location?.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        
        let address = "old capitol mall, Iowa city, USA"
        let geocode = CLGeocoder()
        var coordinates: CLLocationCoordinate2D?
        geocode.geocodeAddressString(address) { (location, error) in
            self.mapView.addAnnotation(MKPlacemark(placemark: (location?[0])!))
            coordinates = location?[0].location!.coordinate
            
            let center = CLLocationCoordinate2D(latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventNameValue: UITextField!
    @IBOutlet weak var eventDescriptionValue: UITextField!
    @IBOutlet weak var dateAndTimeValue: UITextField!
    @IBOutlet weak var locationValue: UITextField!
    @IBOutlet weak var maxCountValue: UITextField!
    
    @IBAction func saveEvent(_ sender: UIButton) {
       /* let newEvent =  Event(name: eventNameValue.text!, description: eventDescriptionValue.text!, dateAndTime: dateAndTimeValue.text!, mapLocation: locationValue.text!, maxCount: Int(maxCountValue.text!)!);
        x.append(newEvent!)
        dataStorage?.set(NSKeyedArchiver.archivedData(withRootObject: x), forKey: "event")
        
        let address = "Maclean Hall, Iowa city, USA"
        let geocode = CLGeocoder()
        var coordinates: CLLocationCoordinate2D?
        geocode.geocodeAddressString(address) { (location, error) in
            coordinates = location?[0].location!.coordinate
            self.mapView.addAnnotation(MKPlacemark(placemark: (location?[0])!))
            
            let center = CLLocationCoordinate2D(latitude: (coordinates?.latitude)!, longitude: (coordinates?.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true) */
        
        let eventName = eventNameValue.text!
        let eventLocation = locationValue.text!
        let eventDescription = eventDescriptionValue.text!
        let eventDateAndTime = dateAndTimeValue.text!
        let eventMaxPeople = maxCountValue.text!
        
        //TODO: Use class constructor instead of separate variables
        let post : [String : AnyObject] = ["eventName" : eventName as AnyObject,
                                           "eventLocation" : eventLocation as AnyObject,
                                           "eventDescription" : eventDescription as AnyObject,
                                           "eventDateAndTime" : eventDateAndTime as AnyObject,
                                           "eventMaxPeople" : eventMaxPeople as AnyObject]
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("events").childByAutoId().setValue(post)
        
        
        
    }
    
   /* func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapView.setRegion(region, animated: true)
        self.location?.stopUpdatingLocation()
    } */
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
