//
//  StoneView.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 4/29/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

class StoneView: UIView {
    private var isSelected: Bool = false
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        backgroundColor = .white
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2
        addGestureRecognizer( UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = frame.width / 3
        super.draw(rect)
    }
    
    @objc func handleTap() {
        isSelected.toggle()
        backgroundColor = isSelected ? .gray : .white
        setNeedsDisplay()
    }
}
