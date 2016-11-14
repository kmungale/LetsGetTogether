//
//  EventDetailsViewController.swift
//  letsGetTogether
//
//  Created by macbook_user on 11/13/16.
//  Copyright © 2016 Kaustubh. All rights reserved.
//

import UIKit
import MapKit

class EventDetailsViewController: UIViewController {
    var selectedEvent: Event!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
