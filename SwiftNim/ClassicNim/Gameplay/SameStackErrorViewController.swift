//
//  SameStackErrorViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/7/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class SameStackErrorViewController: UIViewController {

    @IBOutlet private weak var backgroundView: UIView!

    @IBAction private func ok(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.cornerRadius = 30
        backgroundView.backgroundColor = UIColor(red: 50.0 / 256.0, green: 20.0 / 256.0, blue: 18.0 / 256.0, alpha: 1)
    }
}
