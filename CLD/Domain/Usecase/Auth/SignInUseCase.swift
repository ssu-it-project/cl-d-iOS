//
//  SignInUseCase.swift
//  CLD
//
//  Created by 김규철 on 2023/08/27.
//

import Foundation

import RxSwift

protocol SignInUseCase {
    func tryKakaoSignIn() -> Observable<UserToken>
    func tryAppleSignIn(requestDTO: SignInRequest) -> Single<UserToken>
}

final class DefaultSignInUseCase: SignInUseCase {
    
    private let signInRepository: DefaultSignInRepository
    
    // MARK: - Initializer
    init(repository: DefaultSignInRepository) {
        signInRepository = repository
    }
    
    // MARK: - Methods
    func tryAppleSignIn(requestDTO: SignInRequest) -> Single<UserToken> {
        signInRepository.tryAppleLogin(requestDTO: requestDTO)
    }
    
    public func tryKakaoSignIn() -> Observable<UserToken> {
        signInRepository.tryKakaoLogin()
    }
}
