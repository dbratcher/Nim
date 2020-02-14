//
//  NimViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/4/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class NimViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        // Show some help.
    @IBAction private func showHelp(_ sender: Any) {
        guard let url = URL(string: "https://github.com/dbratcher/nim/issues") else { return }
        UIApplication.shared.open(url)
    }

    // Return whether action can be performed.
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.showHelp(_:)) {
            return true
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = #imageLiteral(resourceName: "Background")
        view.backgroundColor = UIColor(patternImage: backgroundImage)
    }
}
