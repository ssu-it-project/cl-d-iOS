//
//  MyPageViewController.swift
//  CLD
//
//  Created by 김규철 on 2023/07/20.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

class MyPageViewController: BaseViewController {
    lazy var data_All: [History] = [] {
        didSet {
            self.mypageView.badgeCollectionView.reloadData()
        }
    }
    lazy var typeOfHistory: String = ""
    lazy var dataCount: Int = 0
    lazy var skip: Int = 0
    let lableInfo: [String] = ["등반 기록", "방문한 암장", "좋아요", "게시글"]
    lazy var countInfo: [Int] = [0, 0, 0, 0] {
        didSet {
            self.mypageView.countCollectionView.reloadData()
        }
    }
    let categoryLabels: [String] = ["전체", "등반기록", "뱃지"]
    
    let mypageView = MyPageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mypageView.delegatePushSetting = self
        mypageView.countCollectionView.delegate = self
        mypageView.countCollectionView.dataSource = self
        mypageView.badgeCollectionView.delegate = self
        mypageView.badgeCollectionView.dataSource = self
        mypageView.categoryCollectionView.delegate = self
        mypageView.categoryCollectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        getUser()
        skip = 0
        getUserHistory(type: "" , start_date: "" , end_date: "", limit: 10, skip: skip)
    }
    override func setHierarchy() {
        self.view.addSubview(mypageView)
    }
    
    override func setConstraints() {
        mypageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MyPageViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
                                 UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mypageView.countCollectionView {
            return lableInfo.count
        } else if collectionView == mypageView.badgeCollectionView {
            if (self.dataCount == 0) {
                mypageView.badgeCollectionView.setEmptyMessage("기록이 아직 없습니다.")
                return 0
            }
            mypageView.badgeCollectionView.restore()
            print("==== data_All.count: \(data_All.count)")
            return data_All.count
        } else if collectionView == mypageView.categoryCollectionView {
            return categoryLabels.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mypageView.countCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountCollectionViewCell.identifier, for: indexPath) as! CountCollectionViewCell
            cell.countLabel.text = String(countInfo[indexPath.row])
            cell.nameLabel.text = lableInfo[indexPath.row]
            return cell
        } else if collectionView == mypageView.badgeCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCollectionViewCell.identifier, for: indexPath) as! HistoryCollectionViewCell
            cell.delegatePushVideo = self
            let date = data_All[indexPath.row].historyDate.split(separator: "T")
            if (data_All[indexPath.row].type == "record"){
                cell.badgeImageView.setImage(urlString: data_All[indexPath.row].record.holdIcon, defaultImage: ImageLiteral.holderBlue)
                cell.titleLabel.text = data_All[indexPath.row].record.gymName
                cell.titleLabel.textColor = .CLDBlack
                cell.dateLabel.text = "\(date[0]) | 섹터 \(data_All[indexPath.row].record.sector) | \(data_All[indexPath.row].record.level)"
                cell.dateLabel.textColor = .CLDMediumGray
                cell.videoButton.setImage(ImageLiteral.videoIcon, for: .normal)
                cell.cellBackgroundView.backgroundColor = .CLDLightGray
            } else {
                cell.badgeImageView.setImage(urlString: data_All[indexPath.row].userBadge.image, defaultImage: ImageLiteral.testBadgeImage)
                cell.videoButton.setImage(nil, for: .normal)
                cell.titleLabel.textColor = .white
                cell.titleLabel.text = data_All[indexPath.row].userBadge.title
                cell.dateLabel.text = "\(date[0]) 배지 획득"
                cell.dateLabel.textColor = .white
                cell.cellBackgroundView.backgroundColor = .CLDGold
            }
            return cell
        } else if collectionView == mypageView.categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            mypageView.categoryCollectionView.selectItem(at: [0,0], animated: false, scrollPosition: .init())
            cell.setCategory(text: categoryLabels[indexPath.row])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCollectionViewCell.identifier, for: indexPath) as! HistoryCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mypageView.countCollectionView {
            return CGSize(width: 90, height: 72)
        } else if collectionView == mypageView.badgeCollectionView {
            return CGSize(width: 352, height: 76)
        } else if collectionView == mypageView.categoryCollectionView {
            let categoryLabel: UILabel = {
                let label = UILabel()
                label.text = categoryLabels[indexPath.row]
                label.textColor = .CLDBlack
                label.font = RobotoFont.Bold.of(size: 14)
                label.textAlignment = .center
                label.sizeToFit()
                
                return label
            }()
            let size = categoryLabel.frame.size
            return CGSize(width: size.width + 4, height: size.height)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == mypageView.countCollectionView {
            return 0
        } else if collectionView == mypageView.badgeCollectionView {
            return 8
        } else if collectionView == mypageView.categoryCollectionView {
            return 2
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if collectionView == mypageView.countCollectionView {
            print("=== count index: \(indexPath.row)")
        } else if collectionView == mypageView.badgeCollectionView {
        } else if collectionView == mypageView.categoryCollectionView {
            if (index == 0) {
                typeOfHistory = ""
            } else if (index == 1) {
                typeOfHistory = "clime_record"
            } else {
                typeOfHistory = "badge"
            }
            skip = 0
            getUserHistory(type: typeOfHistory , start_date: "" , end_date: "", limit: 10, skip: skip)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.mypageView.badgeCollectionView
        {
            if ( dataCount-skip > 10) {
                skip = skip + 10
                getUserHistory(type: typeOfHistory , start_date: "" , end_date: "", limit: 10, skip: skip)
            }
        }
    }
}

extension MyPageViewController: PushSettingDelegate {
    func settingButtonTapped() {
        let nextViewController = SettingViewController()
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

extension MyPageViewController: PushVideoDelegate {
    func videoButtonTapped() {
        print("==== Video Page로 이동")
    }
}

extension MyPageViewController {
    private func getUser() {
        NetworkService.shared.myPage.getUser() { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response as? UserDTO else { return }
                self?.mypageView.setProfile(imageUrl: data.profile.image, nickname: data.profile.nickname)
                self?.countInfo[0] = data.count.record.post
                self?.countInfo[1] = data.count.record.post
                self?.countInfo[2] = data.count.record.like.received + data.count.community.like.received
                self?.countInfo[3] = data.count.community.post
            case .requestErr(let errorResponse):
                dump(errorResponse)
                guard let data = errorResponse as? ErrorResponse else { return }
                print(data.message ?? "requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    private func getUserHistory(type: String, start_date: String, end_date: String, limit: Int, skip: Int) {
        NetworkService.shared.myPage.getUserHistory(type: type, start_date: start_date, end_date: end_date, limit: limit, skip: skip) { [weak self] result in
            switch result {
            case .success(let response):
                guard let data = response as? UserHistoryDTO
                else {
                    self?.dataCount = 0
                    self?.data_All = []
                    return
                }
                self?.dataCount = data.pagination.total
                if (skip != 0) {
                    self?.data_All.append(contentsOf: data.histories)
                } else {
                    self?.data_All = data.histories
                }
            case .requestErr(let errorResponse):
                dump(errorResponse)
                guard let data = errorResponse as? ErrorResponse else { return }
                print(data.message ?? "requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}
