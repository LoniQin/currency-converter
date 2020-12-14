//
//  SceneDelegate.swift
//  CurrencyConverter
//
//  Created by Lonnie on 2020/12/11.
//
import FoundationLib
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        let file = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let storage: DataStorage!
        if let fileStorage = try? FileStorage(path: file / "app_data", loadAndSaveImmediately: true) {
            storage = fileStorage
        } else {
            storage = UserDefaults.standard
        }
        let viewController = CurrencyConvertionConfigurator.makeViewController(
            configuration: .init(
                httpClient: HttpClient.default,
                storage: storage,
                stringProvider: StringProvider()
            )
        )
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        window?.makeKeyAndVisible()

    }

}

