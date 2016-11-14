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
    var x =  [Event]()
    var location = CLLocationManager()
    let geocode = CLGeocoder()
    var coordinates: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.delegate = self
        //location?.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization()
        //location?.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        let address = "old capitol mall, Iowa city, USA"
        geocode.geocodeAddressString(address) { (location, error) in
            self.mapView.addAnnotation(MKPlacemark(placemark: (location?[0])!))
            self.coordinates = location?[0].location!.coordinate
            
            let center = CLLocationCoordinate2D(latitude: (self.coordinates?.latitude)!, longitude: (self.coordinates?.longitude)!)
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
        let address = self.locationValue.text!
        geocode.geocodeAddressString(address) { (location, error) in
            self.coordinates = location?[0].location!.coordinate
            let eventName = self.eventNameValue.text!
            let eventLocation = self.locationValue.text!
            let eventDescription = self.eventDescriptionValue.text!
            let eventDateAndTime = self.dateAndTimeValue.text!
            let eventMaxPeople = self.maxCountValue.text!
            let destLat = String((self.coordinates?.latitude)!)
            let destLong =  String((self.coordinates?.longitude)!)
            
            //TODO: Use class constructor instead of separate variables
            let post : [String : AnyObject] = ["eventName" : eventName as AnyObject,
                                               "eventLocation" : eventLocation as AnyObject,
                                               "eventDescription" : eventDescription as AnyObject,
                                               "eventDateAndTime" : eventDateAndTime as AnyObject,
                                               "eventMaxPeople" : eventMaxPeople as AnyObject,
                                               "destLat": destLat as AnyObject,
                                               "destLong": destLong as AnyObject]
            
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("events").childByAutoId().setValue(post)
        }
    }
}
