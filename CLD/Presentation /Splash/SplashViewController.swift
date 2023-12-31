//
//  SplashViewController.swift
//  CLD
//
//  Created by 이조은 on 2023/07/20.
//

import UIKit

import SnapKit

final class SplashViewController: BaseViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiteral.cldLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 16.0, *) {
            self.navigationItem.leftBarButtonItem?.isHidden = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            guard let delegate = sceneDelegate else {
                print("sceneDelegate가 할당 Error")
                return
            }
            
            if UserDefaultHandler.loginStatus == true {
                RootHandler.shard.update(.Main)
            } else {
                let rootViewController = AuthViewController(viewModel: SignInViewModel(useCase: DefaultSignInUseCase(repository: DefaultSignInRepository())))
                
                delegate.window?.rootViewController = rootViewController
            }
        }
    }
    
    override func setHierarchy() {
        self.view.addSubview(logoImageView)
    }
    
    override func setConstraints() {
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 78, height: 95))
            $0.top.equalToSuperview().inset(323)
            $0.centerX.equalToSuperview()
        }
    }
}
