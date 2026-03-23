//
//  TutorialContentController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 3/23/26.
//  Copyright © 2026 Drew Bratcher. All rights reserved.
//

import UIKit

class TutorialContentController: UIViewController {
    private let tutorialText: UILabel
    private let tutorialImage: UIImageView
    private let skipButton: UIButton
    private let isFinal: Bool
    let index: Int

    var titleText: String? { tutorialText.text }

    @objc
    func skip() {
        dismiss(animated: true, completion: nil)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(text: String, image: String, isFinal: Bool, index: Int) {
        self.index = index
        self.isFinal = isFinal

        tutorialImage = UIImageView(frame: .zero)
        tutorialImage.contentMode = .scaleAspectFit
        tutorialImage.translatesAutoresizingMaskIntoConstraints = false
        tutorialImage.image = UIImage(named: image)

        tutorialText = UILabel(frame: .zero)
        tutorialText.translatesAutoresizingMaskIntoConstraints = false
        tutorialText.text = text
        tutorialText.textColor = .white
        tutorialText.textAlignment = .center
        tutorialText.font = UIFont(name: "MarkerFelt-Thin", size: 24)
        tutorialText.numberOfLines = 0

        skipButton = UIButton(type: .custom)

        super.init(nibName: nil, bundle: nil)

        let title = isFinal ? "Let's Play!" : "Skip Tutorial"

        skipButton.setTitle(title, for: .normal)
        skipButton.titleLabel?.font = UIFont(name: "MarkerFelt-Thin", size: 18)
        skipButton.setTitleColor(#colorLiteral(red: 0.6064376235, green: 0.8653294444, blue: 0.9825807214, alpha: 1), for: .normal)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.addTarget(self, action: #selector(skip), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [tutorialImage, tutorialText, skipButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        view.addSubview(stackView)
        view.backgroundColor = TutorialViewController.bgColor

        tutorialText.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        skipButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 40).isActive = true
        stackView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 20).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 800).isActive = true
        stackView.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
    }
}
