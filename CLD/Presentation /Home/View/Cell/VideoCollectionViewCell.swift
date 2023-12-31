//
//  VideoCollectionViewCell.swift
//  CLD
//
//  Created by 김규철 on 2023/07/31.
//

import UIKit
import AVFoundation

import SnapKit
import RxSwift
import RxCocoa

final class VideoCollectionViewCell: UICollectionViewCell {
    
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let UILabel = UILabel()
        UILabel.sizeToFit()
        UILabel.font = .systemFont(ofSize: 14)
        UILabel.textColor = .black
        return UILabel
    }()
    fileprivate lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.videoCellMenuIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    var playerView = PlayerView()
    private let viedoTitleLabel: UILabel = {
        let UILabel = UILabel()
        UILabel.sizeToFit()
        UILabel.font = .boldSystemFont(ofSize: 16)
        UILabel.textColor = .black
        return UILabel
    }()
    private let viedoDetailLabel: UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 14)
        UILabel.textColor = .CLDDarkGray
        return UILabel
    }()
    private let viedoDateLabel: UILabel = {
        let UILabel = UILabel()
        UILabel.font = .systemFont(ofSize: 14)
        UILabel.textColor = .CLDDarkGray
        return UILabel
    }()
    private lazy var videoSubTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 1
        stackView.addArrangedSubviews(viedoDetailLabel, viedoDateLabel)
        return stackView
    }()
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.likeIcon, for: .normal)
        button.imageView?.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.commentIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.shareIcon, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.addArrangedSubviews(likeButton, commentButton, shareButton)
        return stackView
    }()
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setHierarchy()
        setConstraints()
        setViewProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        playerView.player = nil
        playerView.resetPlayer()
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
            
    private func setHierarchy() {
        contentView.addSubviews(topLineView, profileImageView, titleLabel, menuButton, playerView, viedoTitleLabel, videoSubTitleStackView, buttonStackView)
    }
    
    private func setConstraints() {
        topLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.top.equalTo(topLineView.snp.bottom).offset(6.5)
            make.leading.equalToSuperview().inset(6)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        menuButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(30)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        playerView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(self.contentView.snp.height).multipliedBy(0.7)
        }
        
        viedoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(6)
        }
        
        videoSubTitleStackView.snp.makeConstraints { make in
            make.top.equalTo(viedoTitleLabel.snp.bottom).offset(3)
            make.leading.equalTo(viedoTitleLabel.snp.leading)
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        
        commentButton.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        
        shareButton.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.leading.equalTo(viedoTitleLabel.snp.trailing).offset(5)
            make.centerY.equalTo(viedoTitleLabel.snp.centerY)
            make.top.equalTo(playerView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().inset(10)
        }
        
        buttonStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        buttonStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private func setViewProperty() {
        self.backgroundColor = .white
    }
}

extension VideoCollectionViewCell {
    func configureVideo(with videoURLString: String) {
        playerView.setupPlayerItem(with: videoURLString)
    }
}

extension VideoCollectionViewCell {
    func configureCell(row: RecordVO) {
        print(URLConst.base + "/\(row.author.profileImage)")
        profileImageView.setImage(urlString: URLConst.base + "/\(row.author.profileImage)", defaultImage: ImageLiteral.myPageIcon)
        titleLabel.text = row.author.nickname
        viedoTitleLabel.text = row.content
        viedoDetailLabel.text = "\(row.climbingGymInfo.name) | \(row.sector) | \(row.level)"
        viedoDateLabel.text = row.date.created.convertToKoreanDateFormat()
    }
}

extension Reactive where Base: VideoCollectionViewCell {
    var menuButtonTapped: Driver<Void> { base.menuButton.rx.tap.asDriver() }
    
    var playerViewTapped: Driver<Void> {
        return base.playerView.rx.tapGesture()
            .when(.recognized)
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
    }
}
