//
//  AppState.swift
//  letsGetTogether
//
//  Created by macbook_user on 11/12/16.
//  Copyright © 2016 Kaustubh. All rights reserved.
//

import Foundation

class AppState: NSObject {
    
    static let sharedInstance = AppState()
    
    var signedIn = false
    var displayName: String?
}
