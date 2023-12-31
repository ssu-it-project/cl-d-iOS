//
//  ClimbingGymDetailUseCase.swift
//  CLD
//
//  Created by 김규철 on 2023/09/14.
//

import Foundation

import RxSwift

enum ClimbingGymDetailError: Error {
    case getDetailGymError
    case postBookmarkError
    case deleteBookmarkError
}

protocol ClimbingGymDetailUseCase: AnyObject {
    func getDetailGym(id: String) -> Single<DetailGymVO>
    func getDetailGymRecord(id: String, keyword: String, limit: Int, skip: Int) -> Single<RecordListVO>
    func postBookmark(id: String) -> Single<Void>
    func deleteBookmark(id: String) -> Single<Void>
}

final class DefaultClimbingGymDetailUseCase: ClimbingGymDetailUseCase {
    
    private let disposeBag = DisposeBag()
    private let gymsRepository: GymsRepository
    
    // MARK: - Initializer
    init(gymsRepository: GymsRepository) {
        self.gymsRepository = gymsRepository
    }
    
    func getDetailGym(id: String) -> Single<DetailGymVO> {
        gymsRepository.getDetailGym(id: id)
    }
    
    func getDetailGymRecord(id: String, keyword: String, limit: Int, skip: Int) -> Single<RecordListVO> {
        gymsRepository.getDetailGymRecord(id: id, keyword: keyword, limit: limit, skip: skip)
    }
    
    func postBookmark(id: String) -> Single<Void> {
        gymsRepository.postBookmark(id: id)
    }
    
    func deleteBookmark(id: String) -> Single<Void> {
        gymsRepository.deleteBookmark(id: id)
    }
}
