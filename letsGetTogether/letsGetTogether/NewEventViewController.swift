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

struct Data {
    var name: String
}

class NewEventViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var ref: FIRDatabaseReference!
    var dataStorage: UserDefaults?
    var location = CLLocationManager()
    let geocode = CLGeocoder()
    var coordinates: CLLocationCoordinate2D?
    var availableLocations = [MKMapItem]()

    
    
    //Programmatic implementing table view
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableLocations.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // cell reuse id (cells that scroll out of view can be reused)
        let cellReuseIdentifier = "cell"
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.locationTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        // set the text from the data model
        cell.textLabel?.text = self.availableLocations[indexPath.row].name
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let selectedLocation = availableLocations[indexPath.row].name
        geocode.geocodeAddressString(selectedLocation!) { (location, error) in
            if((error) != nil || location == nil) {
                let errroAlert = UIAlertController(title: "Invalid Location", message: "Please enter valid location", preferredStyle: UIAlertControllerStyle.alert)
                errroAlert.addAction(UIAlertAction(title: "Dimiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(errroAlert, animated: true, completion: nil)
                return
            }
            let center = CLLocationCoordinate2D(latitude: (location?[0].location!.coordinate.latitude)!, longitude: (location?[0].location!.coordinate.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            self.mapView.addAnnotation(MKPlacemark(coordinate: center))
            self.locationValue.text = selectedLocation!
        }
        locationTable.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location.delegate = self
        //location?.desiredAccuracy = kCLLocationAccuracyBest
        location.requestWhenInUseAuthorization()
        //location?.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        //Programmatic Table view for locations//
        self.locationTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.locationTable.delegate = self
        self.locationTable.dataSource = self
        self.locationTable.alpha = 0
        
        //.......mapping address
        let address = "1305 sunset street, iowa city"
        geocode.geocodeAddressString(address) { (location, error) in
            //self.mapView.addAnnotation(MKPlacemark(placemark: (location?[0])!))
            self.coordinates = location?[0].location!.coordinate
            
            let center = CLLocationCoordinate2D(latitude: (self.coordinates?.latitude)!, longitude: (self.coordinates?.longitude)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AppState.sharedInstance.eventToEdit != nil {
            let eventToEdit = AppState.sharedInstance.eventToEdit
            self.eventNameValue.text = eventToEdit?.eventName
            AppState.sharedInstance.eventToEdit = nil
        }
        else {
            self.eventNameValue.text = ""
            self.eventDescriptionValue.text = ""
            self.locationValue.text = ""
            self.dateAndTimeValue.text = ""
            self.maxCountValue.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var locationTable: UITableView!
    
    @IBAction func searchLocation(_ sender: UITextField) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = self.locationValue.text!
        //request.region = self.mapView.region
        request.region = MKCoordinateRegionMakeWithDistance((self.mapView.userLocation.location?.coordinate)!, 12000000, 12000000)
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.locationTable.alpha = 1
            self.availableLocations = response.mapItems
            self.locationTable.reloadData()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var eventNameValue: UITextField!
    @IBOutlet weak var eventDescriptionValue: UITextField!
    @IBOutlet weak var dateAndTimeValue: UITextField!
    @IBOutlet weak var locationValue: UITextField!
    @IBOutlet weak var maxCountValue: UITextField!
    
    @IBAction func datePicker(_ sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        dateAndTimeValue.text = dateFormatter.string(from: sender.date)
        
    }
    
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
                                               "destLong": destLong as AnyObject,
                                               "createdBy": (AppState.sharedInstance.firstName! + " " + AppState.sharedInstance.lastName!) as AnyObject,
                                               "peopleGoing": 0 as AnyObject,
                                               "uid": (AppState.sharedInstance.uid)! as AnyObject]
            
            let databaseRef = FIRDatabase.database().reference()
            databaseRef.child("events").childByAutoId().setValue(post)
            
            self.eventNameValue.text = ""
            self.eventDescriptionValue.text = ""
            self.locationValue.text = ""
            self.dateAndTimeValue.text = ""
            self.maxCountValue.text = ""
        }
    }
    
}
