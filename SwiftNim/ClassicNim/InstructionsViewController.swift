//
//  InstructionsViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/5/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class InstructionsViewController: NimViewController {
    @IBOutlet private var buildNumber: UILabel!
    @IBOutlet private var lastStoneRule: UILabel!

    @IBAction private func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func viewTutorial(_ sender: Any) {
        present(TutorialViewController.create(), animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let buildNumberString = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        buildNumber.text = "Build Number: \(buildNumberString)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastStoneRule.text = GameSettingsStorage.load().lastStone.ruleDescription
    }
}
