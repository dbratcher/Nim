//
//  SameStackErrorViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/7/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class SameStackErrorViewController: UIViewController {
    @IBOutlet private var backgroundView: UIView!

    @IBAction private func ok(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.layer.cornerRadius = 30
        backgroundView.backgroundColor = #colorLiteral(red: 0.1960784314, green: 0.07843137255, blue: 0.07058823529, alpha: 1)
    }
}
