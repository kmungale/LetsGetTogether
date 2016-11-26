//
//  HostingEventsTableViewCell.swift
//  letsGetTogether
//
//  Created by macbook_user on 11/25/16.
//  Copyright © 2016 Kaustubh. All rights reserved.
//

import UIKit
import Firebase

class HostingEventsTableViewCell: UITableViewCell {

    var editableEvents = [Event]()
    var hostingEventsTable: UITableView?
    var tableReference: MyEventsViewController?
    @IBOutlet weak var deleteEvent: UIButton!
    @IBOutlet weak var editEvent: UIButton!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    
    @IBAction func deleteEventClick(_ sender: UIButton) {
        print(sender.tag)
        self.tableReference?.myHostedEvents.remove(at: sender.tag)
        self.tableReference?.hostingEventsTable.reloadData()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
