//
//  InstructionsViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/5/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class InstructionsViewController: NimViewController {
    @IBOutlet weak var buildNumber: UILabel!

    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let buildNumberString = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        buildNumber.text = "Build Number: \(buildNumberString)"
    }
}
