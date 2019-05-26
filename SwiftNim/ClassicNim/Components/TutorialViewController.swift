//
//  TutorialViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/7/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

typealias PageVC = UIPageViewController

class TutorialViewController: PageVC {

    static func create() -> TutorialViewController {
        let tutorialTitles = ["Each game starts with a board of stones",
                              "Select stones in a single stack to remove 🔘",
                              "Players take turns each removing stones 🤼",
                              "Last person to remove a stone loses 😁"]
        let tutorialImages = ["GameBoard", "SelectStones", "RemoveStones", "DontLose"]
        return TutorialViewController(titles: tutorialTitles, images: tutorialImages, bgColor: #colorLiteral(red: 0.3529411765, green: 0.2862745098, blue: 0.2549019608, alpha: 1))
    }

    private let titles: [String]
    private let images: [String]
    private let bgColor: UIColor

    init(titles: [String], images: [String], bgColor: UIColor) {
        self.titles = titles
        self.images = images
        self.bgColor = bgColor
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        view.backgroundColor = bgColor

        dataSource = self
        guard let firstVC = viewControllerAtIndex(index: 0) else {
            assert(false, "Failed to setup page view controller.")
            dismiss(animated: true, completion: nil)
            
            return
        }
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TutorialViewController: UIPageViewControllerDataSource {
    func pageViewController(_ page: PageVC, viewControllerBefore current: UIViewController) -> UIViewController? {
        guard let currentPage = current as? TutorialContentController else { return nil }
        guard let currentTitle = currentPage.titleText else { return nil }
        guard let index = titles.firstIndex(of: currentTitle) else { return nil }

        return viewControllerAtIndex(index: index - 1)
    }

    func pageViewController(_ page: PageVC, viewControllerAfter current: UIViewController) -> UIViewController? {
        guard let currentPage = current as? TutorialContentController else { return nil }
        guard let currentTitle = currentPage.titleText else { return nil }
        guard let index = titles.firstIndex(of: currentTitle) else { return nil }

        return viewControllerAtIndex(index: index + 1)
    }

    func viewControllerAtIndex(index: Int) -> UIViewController? {
        guard index >= 0 else { return nil }
        guard index < titles.count else { return nil }

        let isFinal = index == titles.count - 1
        return TutorialContentController(text: titles[index], image: images[index], bgColor: bgColor, isFinal: isFinal)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return titles.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

class TutorialContentController: UIViewController {
    private let tutorialText: UILabel
    private let tutorialImage: UIImageView
    private let skipButton: UIButton
    private let isFinal: Bool

    var titleText: String? {
        return tutorialText.text
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }

    init(text: String, image: String, bgColor: UIColor, isFinal: Bool) {
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
        view.backgroundColor = bgColor

        tutorialText.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        skipButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 20).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 40).isActive = true
        stackView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 20).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualToConstant: 800).isActive = true
        stackView.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
    }

    @objc func skip() {
        dismiss(animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
