//
//  EventsListTableViewController.swift
//  iOS-project-16
//
//  Created by macbook_user on 10/29/16.
//  Copyright © 2016 Kaustubh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct event {
    let eventLocation : String!
    let eventName : String!
    let eventDescription : String!
    let eventDateAndTime : String!
    let eventMaxPeople : String!
    
}


class EventsListTableViewController: UITableViewController {

    var events1 = [event]()
    var ref: FIRDatabaseReference!
    var remoteConfig: FIRRemoteConfig!
    var dataStorage: UserDefaults?
    fileprivate var _refHandle: FIRDatabaseHandle!
    
 
    
    override func viewDidAppear(_ animated: Bool) {
        //events = NSKeyedUnarchiver.unarchiveObject(with: dataStorage?.object(forKey: "event") as! Data) as! [Event]
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("events").queryOrderedByKey().observe(.childAdded, with: {
            
            snapshot in
            
            let eventName = (snapshot.value! as? [String : String])?["eventName"]
            let eventLocation = (snapshot.value! as? [String : String])?["eventLocation"]
            let eventDescription = (snapshot.value! as? [String : String])?["eventDescription"]
            let eventDateAndTime = (snapshot.value! as? [String : String])?["eventDateAndTime"]
            let eventMaxPeople = (snapshot.value! as? [String : String])?["eventMaxPeople"]
            
            self.events1.insert(event(eventLocation : eventLocation, eventName : eventName, eventDescription : eventDescription, eventDateAndTime : eventDateAndTime, eventMaxPeople : eventMaxPeople) , at: 0)
            self.tableView.reloadData()
            
            
            
        })
        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events1.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "EventTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EventTableViewCell
        
        // Configure the cell...
        
        cell.eventName.text = events1[indexPath.row].eventName
        cell.eventLocation.text = events1[indexPath.row].eventLocation
        cell.eventDateTime.text = events1[indexPath.row].eventDateAndTime
        
        return cell
        
        
    }
    
    @IBAction func Logout(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AppState.sharedInstance.signedIn = false
            dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
        
    }


}
