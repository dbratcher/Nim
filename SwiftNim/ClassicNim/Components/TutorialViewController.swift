//
//  TutorialViewController.swift
//  ClassicNim
//
//  Created by Drew Bratcher on 5/7/19.
//  Copyright © 2019 Drew Bratcher. All rights reserved.
//

import UIKit

typealias PageVC = UIPageViewController

class TutorialViewController: PageVC, UIPageViewControllerDelegate {
    static func create() -> TutorialViewController {
        let tutorialTitles = ["Each game starts with a board of stones",
                              "Select stones in a single stack to remove 🔘",
                              "Players take turns each removing stones 🤼",
                              "Last person to remove a stone loses 😁"]
        let tutorialImages = ["GameBoard", "SelectStones", "RemoveStones", "DontLose"]
        return TutorialViewController(titles: tutorialTitles, images: tutorialImages)
    }

    private let titles: [String]
    private let images: [String]
    static let bgColor: UIColor = #colorLiteral(red: 0.3529411765, green: 0.2862745098, blue: 0.2549019608, alpha: 1)

    private let nextButton: UIButton
    private let prevButton: UIButton

    private var currentIndex = 0

    init(titles: [String], images: [String]) {
        self.nextButton = UIButton(type: .custom)
        self.prevButton = UIButton(type: .custom)
        self.titles = titles
        self.images = images
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

        view.backgroundColor = TutorialViewController.bgColor

        prevButton.setTitle("Previous", for: .normal)
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(prevButton)
        let prevLeadingAnchor = view.safeAreaLayoutGuide.leadingAnchor
        prevButton.leadingAnchor.constraint(equalTo: prevLeadingAnchor, constant: 10).isActive = true
        let prevBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        prevButton.bottomAnchor.constraint(equalTo: prevBottomAnchor, constant: -10).isActive = true
        prevButton.addTarget(self, action: #selector(prevAction), for: .touchUpInside)
        prevButton.isHidden = true
        prevButton.setTitleColor(#colorLiteral(red: 0.6064376235, green: 0.8653294444, blue: 0.9825807214, alpha: 1), for: .normal)

        nextButton.setTitle("Next", for: .normal)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        let nextTrailingAnchor = view.safeAreaLayoutGuide.trailingAnchor
        nextButton.trailingAnchor.constraint(equalTo: nextTrailingAnchor, constant: -10).isActive = true
        let nextBottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        nextButton.bottomAnchor.constraint(equalTo: nextBottomAnchor, constant: -10).isActive = true
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        nextButton.setTitleColor(#colorLiteral(red: 0.6064376235, green: 0.8653294444, blue: 0.9825807214, alpha: 1), for: .normal)

        delegate = self
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

    @objc
    private func nextAction() {
        guard let currentVC = self.viewControllers?.first as? TutorialContentController else { return }

        let nextIndex = currentVC.index + 1
        guard let nextVC = viewControllerAtIndex(index: nextIndex) as? TutorialContentController else { return }

        setViewControllers([nextVC], direction: .forward, animated: true) { [weak self] _ in
            guard let self else { return }
            self.currentIndex = nextIndex
            self.updateUI()
            self.setViewControllers([nextVC], direction: .forward, animated: false, completion: nil)
        }
    }

    @objc
    private func prevAction() {
        guard let currentVC = viewControllers?.first as? TutorialContentController else { return }

        let prevIndex = currentVC.index - 1
        guard let prevVC = viewControllerAtIndex(index: prevIndex) as? TutorialContentController else { return }

        setViewControllers([prevVC], direction: .reverse, animated: true) { [weak self] _ in
            guard let self else { return }
            self.currentIndex = prevIndex
            self.updateUI()
            self.setViewControllers([prevVC], direction: .reverse, animated: false, completion: nil)
        }
    }

    @objc
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed, let currentVC = viewControllers?.first as? TutorialContentController else { return }

        currentIndex = currentVC.index
        updateUI()
    }

    private func updateUI() {
        prevButton.isHidden = currentIndex == 0
        nextButton.isHidden = currentIndex == titles.count - 1
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
        return TutorialContentController(text: titles[index], image: images[index], isFinal: isFinal, index: index)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int { titles.count }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int { currentIndex }
}
