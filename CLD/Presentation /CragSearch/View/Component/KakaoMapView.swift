//
//  KakaoMapView.swift
//  CLD
//
//  Created by 김규철 on 2023/09/05.
//

import UIKit

final class KakaoMapView: UIView {
    
    let mapView: MTMapView = {
        let mapView = MTMapView()
        mapView.baseMapType = .standard
        mapView.clipsToBounds = true
        return mapView
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = RobotoFont.Bold.of(size: 15)
        label.numberOfLines = 2
        label.textColor = .black    
        return label
    }()
    private let phoneNumberLabel: UILabel = {
        let UILabel = UILabel()
        UILabel.sizeToFit()
        UILabel.font = RobotoFont.Medium.of(size: 15)
        UILabel.textColor = .CLDDarkGray
        return UILabel
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
        self.layer.cornerRadius = 11
        mapView.layer.cornerRadius = 11
    }
    
    private func setHierarchy() {
        addSubviews(mapView, addressLabel, phoneNumberLabel)
    }
    
    private func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(180)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(15)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(10).priority(.high)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(6)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(10).priority(.high)
            make.height.equalTo(addressLabel.snp.height)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}

extension KakaoMapView {
    func createPin(itemName: String, getla: Double, getlo: Double) {
        let poiItem = MTMapPOIItem()
        poiItem.itemName = itemName
        poiItem.mapPoint = MTMapPoint(geoCoord: MTMapPointGeo(latitude: getla, longitude: getlo))
        poiItem.markerType = .bluePin
        poiItem.markerSelectedType = .redPin
        mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude: getla, longitude: getlo)), animated: true)
        mapView.addPOIItems([poiItem])
        mapView.fitAreaToShowAllPOIItems()
    }
}

extension KakaoMapView {
    func configurationVIew(_ detailPlaceVO: DetailPlaceVO) {
        addressLabel.text = detailPlaceVO.addressName
        if detailPlaceVO.phone.isEmpty {
            phoneNumberLabel.text = "전화번호 정보가 없어요"
        } else  {
            phoneNumberLabel.text = detailPlaceVO.phone
        }
    }
}
