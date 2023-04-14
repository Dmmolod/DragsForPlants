//
//  SceneDelegate.swift
//  DrugsForPlants
//
//  Created by Дмитрий Молодецкий on 14.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = DrugsListViewController(
            viewModel:
                DrugsListViewModelImpl(
                    drugsListApiClient: DrugsListApiClient()
                )
        )
        window?.makeKeyAndVisible()
    }
}

