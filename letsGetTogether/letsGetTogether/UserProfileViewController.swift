//
//  UserProfileViewController.swift
//  letsGetTogether
//
//  Created by macbook_user on 11/24/16.
//  Copyright © 2016 Kaustubh. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailInput.isUserInteractionEnabled = false
        emailInput.text = AppState.sharedInstance.email
        firstNameInput.text = AppState.sharedInstance.firstName
        lastNameInput.text = AppState.sharedInstance.lastName
        // Do any additional setup after loading the view.
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
