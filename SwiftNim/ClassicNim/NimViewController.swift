//
//  NimViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/4/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class NimViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = #imageLiteral(resourceName: "Background")
        view.backgroundColor = UIColor(patternImage: backgroundImage)
    }
}
