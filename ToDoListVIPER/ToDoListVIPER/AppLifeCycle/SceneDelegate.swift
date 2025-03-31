//
//  SceneDelegate.swift
//  ToDoListVIPER
//
//  Created by Илья Иванов on 26.03.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        guard let window = window else { return }
        let initialViewController = TodoListRouter.createModule()

        window.rootViewController = UINavigationController(rootViewController: initialViewController)
        window.makeKeyAndVisible()
        self.window = window
    }
}

