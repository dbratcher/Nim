//
//  UIButton.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/4/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

extension UIButton {
    override open var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}
