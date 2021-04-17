//
//  SceneDelegate.swift
//  tasks_UI
//
//  Created by Nihad on 4/15/21.
//

import UIKit

//============================================================================
class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?

    //----------------------------------------------------------------------------
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
    }
}

