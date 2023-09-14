//
//  MyPageView.swift
//  CLD
//
//  Created by 이조은 on 2023/09/13.
//

import UIKit

import SnapKit

final class MyPageView: UIView {
    private let contentView = UIView()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiteral.testProfileImage
        imageView.layer.cornerRadius = 23
        imageView.clipsToBounds = true

        return imageView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Black", size: 13.0)
        label.text = "돌잡이님"
        label.textColor = .black
        label.textAlignment = .left

        return label
    }()
    private let settingButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiteral.settingIcon, for: .normal)

        return button
    }()

    let countCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .CLDLightGray
        collectionView.layer.cornerRadius = 10
        collectionView.isScrollEnabled = false
        collectionView.register(CountCollectionViewCell.self,
                                forCellWithReuseIdentifier: CountCollectionViewCell.identifier)

        return collectionView
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Roboto-Medium", size: 13.0)
        label.text = "<2023년 6월>"
        label.textColor = .black
        label.textAlignment = .left

        return label
    }()
    let badgeCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.register(HistoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: HistoryCollectionViewCell.identifier)

        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setHierarchy()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setHierarchy() {
        addSubviews(contentView, countCollectionView, dateLabel, badgeCollectionView)
        contentView.addSubviews(profileImageView, nameLabel, settingButton)
    }

    func setConstraints() {
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(55)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(46)
        }
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(18)
            $0.size.equalTo(46)
        }
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        settingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(31)
            $0.width.equalTo(17)
            $0.height.equalTo(15)
        }
        countCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(360)
            $0.height.equalTo(72)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(countCollectionView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(21)
        }
        badgeCollectionView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(23)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(360)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}