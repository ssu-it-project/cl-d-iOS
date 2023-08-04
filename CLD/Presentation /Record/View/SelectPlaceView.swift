//
//  SelectPlaceView.swift
//  CLD
//
//  Created by 이조은 on 2023/07/29.
//

import UIKit

import SnapKit

final class SelectPlaceView: UIView {
    private let searchIconView: UIImageView = {
        let view = UIImageView()
        view.image = ImageLiteral.searchIcon
        view.image = view.image?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .CLDGray
        view.backgroundColor = nil
        return view
    }()
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "장소를 입력해주세요."
        textField.font = UIFont(name: "Roboto-Regular", size: 15)
        textField.textColor = .CLDBlack
        textField.backgroundColor = .CLDLightGray
        textField.borderStyle = .none
        return textField
    }()
    private let underLine: CALayer = {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 30, width: 337, height: 1)
        border.backgroundColor = UIColor.CLDGold.cgColor
        return border
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setConstraints()
        
        searchTextField.addLeftPadding()
        searchTextField.addLeftImage(image: ImageLiteral.searchIcon)
        
        searchTextField.layer.addSublayer((underLine))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHierarchy() {
        addSubviews(searchTextField)
    }
    
    func setConstraints() {
        searchTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(25)
            $0.width.equalTo(337)
            $0.height.equalTo(31)
        }
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 31))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    func addLeftImage(image: UIImage) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 31))
        let letfImage = UIImageView(frame:CGRect(x: 8, y: 9, width: 13, height: 13))
        letfImage.image = image.resize(newWidth: CGFloat(13))
        letfImage.image = letfImage.image?.withRenderingMode(.alwaysTemplate)
        letfImage.tintColor = .CLDGray
        letfImage.backgroundColor = nil
        paddingView.addSubview(letfImage)
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
