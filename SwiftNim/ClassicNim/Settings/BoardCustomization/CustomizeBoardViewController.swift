//
//  CustomizeBoardViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/20/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class CustomizeBoardViewController: UIViewController {
    
    @IBOutlet weak var stackNumber: UISegmentedControl!
    
    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

