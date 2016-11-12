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

    //var events1 = [Event]()
    var events1 = [event]()
    var ref: FIRDatabaseReference!
    //var events: [FIRDataSnapshot]! = []
    var remoteConfig: FIRRemoteConfig!
    
    
    var dataStorage: UserDefaults?
    fileprivate var _refHandle: FIRDatabaseHandle!
    
//    deinit {
//        self.ref.child("events").removeObserver(withHandle: _refHandle)
//    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        // Listen for new messages in the Firebase database
        //ref.child("events").observeSingleEvent(of: .childAdded, with: { (snapshot) in
            //print(snapshot);
        //})
    }
    
    func configureRemoteConfig() {
        remoteConfig = FIRRemoteConfig.remoteConfig()
        // Create Remote Config Setting to enable developer mode.
        // Fetching configs from the server is normally limited to 5 requests per hour.
        // Enabling developer mode allows many more requests to be made per hour, so developers
        // can test different config values during development.
        let remoteConfigSettings = FIRRemoteConfigSettings(developerModeEnabled: true)
        remoteConfig.configSettings = remoteConfigSettings!
    }
    
    func fetchConfig() {
        var expirationDuration: Double = 3600
        // If in developer mode cacheExpiration is set to 0 so each fetch will retrieve values from
        // the server.
        if (self.remoteConfig.configSettings.isDeveloperModeEnabled) {
            expirationDuration = 0
        }
        
        // cacheExpirationSeconds is set to cacheExpiration here, indicating that any previously
        // fetched and cached config would be considered expired because it would have been fetched
        // more than cacheExpiration seconds ago. Thus the next fetch would go to the server unless
        // throttling is in progress. The default expiration duration is 43200 (12 hours).
        remoteConfig.fetch(withExpirationDuration: expirationDuration) { (status, error) in
            if (status == .success) {
                print("Config fetched!")
                self.remoteConfig.activateFetched()
            } else {
                print("Config not fetched")
                print("Error \(error)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //events = NSKeyedUnarchiver.unarchiveObject(with: dataStorage?.object(forKey: "event") as! Data) as! [Event]
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //initialPost()
        //dataStorage = UserDefaults.standard
        //events = NSKeyedUnarchiver.unarchiveObject(with: dataStorage?.object(forKey: "event") as! Data) as! [Event]
        //print(events)
        
        //configureDatabase()
        //configureRemoteConfig()
        //fetchConfig()
        //configureDatabase()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        /*let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("events").queryOrderedByKey().observeSingleEvent(of: .childAdded, with: {
            
            snapshot in
            
            let eventName = snapshot.value!["eventName"] as! String
            let eventLocation = snapshot.value!["eventLocation"] as! String
            
            
        }) */
        
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
    
    func initialPost(){
        
        let eventName = "Halloween"
        let eventLocation = "California"
        
        let post : [String : AnyObject] = ["eventName" : eventName as AnyObject,
                                           "eventLocation" : eventLocation as AnyObject]
        
        let databaseRef = FIRDatabase.database().reference()
        databaseRef.child("events").childByAutoId().setValue(post)
        
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
        //let currentEvent = events1[indexPath.row]
        //cell.eventName.text = currentEvent.eventName
        //cell.eventLocation.text = currentEvent.mapLocation
        //cell.eventDateTime.text = currentEvent.dateAndTime
        // Configure the cell...
        
        cell.eventName.text = events1[indexPath.row].eventName
        cell.eventLocation.text = events1[indexPath.row].eventLocation
        cell.eventDateTime.text = events1[indexPath.row].eventDateAndTime
        
        return cell
        
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
