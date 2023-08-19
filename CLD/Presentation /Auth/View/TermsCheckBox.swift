//
//  TermsCheckBox.swift
//  CLD
//
//  Created by 김규철 on 2023/08/17.
//

import UIKit

import SnapKit

final class TermsCheckBox: UIView {
    private let checkButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.checkIcon, for: .normal)
        button.tintColor = UIColor.black
        button.layer.borderWidth = 0.8
        button.layer.borderColor = UIColor.CLDBlack.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    private let checkLabel: UILabel = {
        let label = UILabel()
        label.text = "전체 동의하기"
        label.textColor = .CLDBlack
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 0.8
        self.layer.borderColor = UIColor.CLDDarkGray.cgColor
        self.backgroundColor = .white
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 5
    }
    
    private func setHierarchy() {
        addSubviews(checkButton, checkLabel)
    }
    
    private func setConstraints() {
        checkButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(14)
            make.size.equalTo(CGSize(width: 28, height: 28))
        }
        
        checkLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkButton.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
    }
}
