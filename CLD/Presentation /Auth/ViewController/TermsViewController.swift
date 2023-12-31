//
//  TermsViewController.swift
//  CLD
//
//  Created by 김규철 on 2023/08/15.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import RxGesture

final class TermsViewController: BaseViewController {
    
    private let badgeTitleLabel: UILabel = {
        let UILabel = UILabel()
        UILabel.sizeToFit()
        UILabel.font = .boldSystemFont(ofSize: 20)
        UILabel.textColor = .CLDBlack
        UILabel.numberOfLines = 0
        UILabel.textAlignment = .left
        UILabel.text = "환영해요! 가입하려면\n약관에 동의가 필요해요."
        return UILabel
    }()
    private let allTermsCheckBox = TermsCheckBox()
    private let useRequiredTermsCheckView = TermsCheckListView(tag: 0, title: TermsType.termsOfUseRequired.description)
    private let personalInfoTermsCheckView = TermsCheckListView(tag: 1, title: TermsType.personalInfoCollectionRequired.description)
    private let eventInfoTermsCheckView = TermsCheckListView(tag: 2, title: TermsType.eventInfoConsent.description)
    private lazy var termsStackView = createTotalStackView()
    private var signUpButton = CLDButton(title: "확인", isEnabled: false)
    
    private let viewModel: SignUpViewModel
    
    // MARK: - Inits
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "회원가입"
        bind()
        bindAction()
        useRequiredTermsCheckView.delegate = self
        personalInfoTermsCheckView.delegate = self
        eventInfoTermsCheckView.delegate = self
        
        if #available(iOS 16.0, *) {
            self.navigationItem.leftBarButtonItem?.isHidden = true
        }
    }
    
    private func bind() {
        let input = SignUpViewModel.Input(totalTerms: allTermsCheckBox.termsCheckBoxDidTapGesture().asObservable(), useRequiredTerms: useRequiredTermsCheckView.termsCheckButton.rx.isSelected.asObservable(), personalInfoTerms: personalInfoTermsCheckView.termsCheckButton.rx.isSelected.asObservable(), eventInfoTerms: eventInfoTermsCheckView.termsCheckButton.rx.isSelected.asObservable(), signUpButtonTapped: signUpButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.nextButtonEnabled
            .asSignal(onErrorJustReturn: false)
            .emit(to: signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.totalTermsChecked
            .withUnretained(self)
            .bind(onNext: { owner, toggle in
                owner.allTermsCheckBox.termsCheckBoxTapped = toggle
                owner.allTermsCheckBox.isSelected = toggle
            })
            .disposed(by: disposeBag)
        
        output.didSuccessSignUp
            .bind { _ in
                print("회원가입 성공 ==== ", UserDefaultHandler.accessToken)
                RootHandler.shard.update(.Main)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindAction() {
        allTermsCheckBox.termsCheckBoxToggleisSeleted()
            .withUnretained(self)
            .emit(onNext: { owner, toggle in
                owner.useRequiredTermsCheckView.termsCheckButton.rx.isSelected.onNext(toggle)
                owner.personalInfoTermsCheckView.termsCheckButton.rx.isSelected.onNext(toggle)
                owner.eventInfoTermsCheckView.termsCheckButton.rx.isSelected.onNext(toggle)
            })
            .disposed(by: disposeBag)
    }
    
    override func setHierarchy() {
        view.addSubviews(badgeTitleLabel, allTermsCheckBox, termsStackView, signUpButton)
    }
    
    override func setConstraints() {
        badgeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(21)
            make.height.equalTo(60)
        }
        
        allTermsCheckBox.snp.makeConstraints { make in
            make.top.equalTo(badgeTitleLabel.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(12)
            make.height.equalTo(50)
        }
        
        termsStackView.snp.makeConstraints { make in
            make.top.equalTo(allTermsCheckBox.snp.bottom).offset(26)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(termsStackView.snp.bottom).offset(15).priority(.low)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-15)
        }
    }
    
    private func createTotalStackView() -> UIStackView {
        let subviews = [useRequiredTermsCheckView, personalInfoTermsCheckView, eventInfoTermsCheckView]
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }
}

extension TermsViewController: PushTermsViewDelegate {
    func detailButtonTapped(index: Int) {
        let vc = TermsWebViewController()
        vc.termsUrl = TermsType.allCases[index].url
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


