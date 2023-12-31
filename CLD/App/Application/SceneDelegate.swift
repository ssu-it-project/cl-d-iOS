//
//  SceneDelegate.swift
//  CLD
//
//  Created by 김규철 on 2023/07/11.
//

import UIKit

import KakaoSDKAuth
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootViewController = UINavigationController(rootViewController: SplashViewController())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    func changeRootView() {
        guard let window = window else { return }
        window.rootViewController = UINavigationController(rootViewController: TabBarController())
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil)
    }

    func changeRootSplashView() {
        guard let window = window else { return }
        window.rootViewController = UINavigationController(rootViewController: SplashViewController())
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    // kakao -> 로그인 코드 작동
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            } else {
                // 페이스북
                ApplicationDelegate.shared.application(
                    UIApplication.shared,
                    open: url,
                    sourceApplication: nil,
                    annotation: [UIApplication.OpenURLOptionsKey.annotation]
                )
            }
        }
    }
    
    
}

