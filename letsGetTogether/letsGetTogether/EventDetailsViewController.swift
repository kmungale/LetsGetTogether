//
//  EventDetailsViewController.swift
//  letsGetTogether
//
//  Created by macbook_user on 11/13/16.
//  Copyright © 2016 Kaustubh. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import Firebase

class EventDetailsViewController: UIViewController {
    var selectedEvent: Event!
    var selectedEventKey: String?
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var interestedImage: UIImageView!
    
    override func viewDidAppear(_ animated: Bool) {
        if AppState.sharedInstance.interestedEvents.contains((selectedEventKey)!) {
            interestedImage.accessibilityIdentifier = "y"
            self.interestedImage.image = UIImage(named: "interested")
        } else {
            interestedImage.accessibilityIdentifier = "n"
            self.interestedImage.image = UIImage(named: "notInterested")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapInterestedImage))
        interestedImage.addGestureRecognizer(tap)
        interestedImage.isUserInteractionEnabled = true
        
        eventNameLabel.text = selectedEvent.eventName
        descriptionLabel.text = selectedEvent.eventDescription
        dateTimeLabel.text = selectedEvent.dateAndTime
        locationLabel.text = selectedEvent.mapLocation
        // Do any additional setup after loading the view.
    
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(selectedEvent.destLat)!, longitude: CLLocationDegrees(selectedEvent.destLong)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        mapView.addAnnotation(MKPlacemark(coordinate: center))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapInterestedImage() {
        let databaseRef = FIRDatabase.database().reference()
        
        if self.interestedImage.accessibilityIdentifier == "n" {
            self.interestedImage.image = UIImage(named: "interested")
            self.interestedImage.accessibilityIdentifier = "y"
            AppState.sharedInstance.interestedEvents.append(selectedEventKey!)
            databaseRef.child("users").child(AppState.sharedInstance.uid!).updateChildValues(["interestedEvents": AppState.sharedInstance.interestedEvents])
        }
        else {
            let eventIndex = AppState.sharedInstance.interestedEvents.index(of: selectedEventKey!)
            AppState.sharedInstance.interestedEvents.remove(at: (eventIndex)!)
            databaseRef.child("users").child(AppState.sharedInstance.uid!).updateChildValues(["interestedEvents": AppState.sharedInstance.interestedEvents])
            self.interestedImage.image = UIImage(named: "notInterested")
            self.interestedImage.accessibilityIdentifier = "n"
        }
        
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
