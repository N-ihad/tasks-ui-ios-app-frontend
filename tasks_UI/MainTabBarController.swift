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
        let templateMatchingNavigationController = templateNavigationController(image: UIImage(systemName: "house")!,
                                                   tabBarItemTitle: "Template Matching",
                                                   rootViewController: templateMatchingViewController)

        let violaJonesViewController  = ViolaJonesViewController()
        let violaJonesNavigationController = templateNavigationController(image: UIImage(systemName: "house")!,
                                                   tabBarItemTitle: "Viola Jones",
                                                   rootViewController: violaJonesViewController)

        let thirdTaskViewController  = ThirdTaskViewController()
        let thirdTaskNavigationController = templateNavigationController(image: UIImage(systemName: "house")!,
                                                   tabBarItemTitle: "Third Task",
                                                   rootViewController: thirdTaskViewController)
        
        viewControllers = [templateMatchingNavigationController, violaJonesNavigationController, thirdTaskNavigationController]
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
