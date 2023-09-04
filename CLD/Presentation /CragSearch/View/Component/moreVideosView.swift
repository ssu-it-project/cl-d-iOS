//
//  seeMoreVideosView.swift
//  CLD
//
//  Created by 김규철 on 2023/09/05.
//

import UIKit

final class moreVideosView: UIView {
    
    private let videoButton: UIButton = {
        let button = UIButton()
        button.setTitle("영상 더보기", for: .normal)
        button.setTitleColor(.CLDBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: 10)
        button.backgroundColor = .white
        button.clipsToBounds = true
        return button
    }()
    private let levelLabel = LevelBadge(title: "A|빨강", backgroundColor: .red)
    private let videoSampleImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "videoCellProfleImage")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .CLDGray
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        videoButton.layer.cornerRadius = 11
        self.layer.cornerRadius = 11
    }
    
    private func setHierarchy() {
        addSubviews(videoButton, videoSampleImageView)
        videoSampleImageView.addSubview(levelLabel)
    }
    
    private func setConstraints() {
        videoButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(27)
            make.height.equalTo(25)
        }

        videoSampleImageView.snp.makeConstraints { make in
            make.top.equalTo(videoButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(27)
            make.bottom.equalToSuperview()
        }
        
        levelLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(6)
            make.centerX.equalToSuperview()
        }
    }
}