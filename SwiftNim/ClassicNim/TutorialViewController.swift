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
    let pageTitles = ["Yo", "Always", "Jump", "Control"]
    let pageImages = ["AppIcon", "AppIcon", "AppIcon", "AppIcon"]

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        dataSource = self
        guard let firstVC = viewControllerAtIndex(index: 0) else {
            assert(false, "Failed to setup page view controller.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TutorialViewController: UIPageViewControllerDataSource {
    func pageViewController(_ page: PageVC, viewControllerBefore view: UIViewController) -> UIViewController? {
        guard let currentPage = view as? TutorialContentController else { return nil }
        guard let index = pageTitles.firstIndex(of: currentPage.titleText) else { return nil }

        return viewControllerAtIndex(index: index - 1)
    }

    func pageViewController(_ page: PageVC, viewControllerAfter view: UIViewController) -> UIViewController? {
        guard let currentPage = view as? TutorialContentController else { return nil }
        guard let index = pageTitles.firstIndex(of: currentPage.titleText) else { return nil }

        return viewControllerAtIndex(index: index + 1)
    }

    func viewControllerAtIndex(index: Int) -> UIViewController? {
        guard index >= 0 else { return nil }
        guard index < pageTitles.count else { return nil }

        let pageContent = TutorialContentController(text: pageTitles[index], imageName: pageImages[index])

        return pageContent
    }

    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }

    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

class TutorialContentController: NimViewController {
    let tutorialText: UILabel
    let tutorialImage: UIImageView

    var titleText = "Testing"
    var imageFile = "blank"

    init(text: String, imageName: String) {
        tutorialText = UILabel(frame: .zero)
        tutorialText.translatesAutoresizingMaskIntoConstraints = false
        tutorialImage = UIImageView(frame: .zero)
        tutorialImage.translatesAutoresizingMaskIntoConstraints = false
        tutorialText.text = text
        tutorialImage.image = UIImage(named: imageName)

        super.init(nibName: nil, bundle: nil)

        view.addSubview(tutorialImage)
        view.addSubview(tutorialText)

        tutorialImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tutorialImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tutorialText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tutorialText.topAnchor.constraint(equalTo: tutorialImage.bottomAnchor, constant: 20).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
