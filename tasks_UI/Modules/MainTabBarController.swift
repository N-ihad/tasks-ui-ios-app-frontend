//
//  MainTabBarController.swift
//  tasks_UI
//
//  Created by Nihad on 4/15/21.
//

import UIKit

//============================================================================
class MainTabBarController: UITabBarController
{
    //----------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()

        style()
        configureViewControllers()
    }

    //----------------------------------------------------------------------------
    private func style()
    {
        tabBar.isTranslucent = false
        tabBar.tintColor = .black
    }

    //----------------------------------------------------------------------------
    private func configureViewControllers()
    {
        let templateMatchingViewController  = TemplateMatchingViewController()
        let templateMatchingNavigationController = templateNavigationController(image: UIImage(systemName: "square.grid.3x3.middle.fill")!,
                                                   tabBarItemTitle: "Template Matching",
                                                   rootViewController: templateMatchingViewController)

        let violaJonesViewController  = ViolaJonesViewController()
        let violaJonesNavigationController = templateNavigationController(image: UIImage(systemName: "square.grid.2x2")!,
                                                   tabBarItemTitle: "Viola Jones",
                                                   rootViewController: violaJonesViewController)

        let symmetryLinesViewController = SymmetryLinesViewController()
        let symmetryLinesNavigationController = templateNavigationController(image: UIImage(systemName: "pause")!,
                                                   tabBarItemTitle: "Symmetry Lines",
                                                   rootViewController: symmetryLinesViewController)

        let thirdTaskViewController  = ThirdTaskViewController()
        let thirdTaskNavigationController = templateNavigationController(image: UIImage(systemName: "chart.bar")!,
                                                   tabBarItemTitle: "3-4 Task",
                                                   rootViewController: thirdTaskViewController)
        
        viewControllers = [templateMatchingNavigationController, violaJonesNavigationController, symmetryLinesNavigationController, thirdTaskNavigationController]
    }

    //----------------------------------------------------------------------------
    private func templateNavigationController(image: UIImage,
                                              tabBarItemTitle: String,
                                              rootViewController: UIViewController) -> UINavigationController
    {
        let templateNavigationController = UINavigationController(rootViewController: rootViewController)
        templateNavigationController.tabBarItem.image = image
        templateNavigationController.tabBarItem.title = tabBarItemTitle

        return templateNavigationController
    }
}
