//
//  RecordUseCase.swift
//  CLD
//
//  Created by 김규철 on 2023/09/13.
//

import Foundation

import RxSwift

enum RecordError: Error {
    case getRecordError
    case postReportError
}

protocol HomeRecordUseCase {
    func getHomeRecords(limit: Int, skip: Int) -> Single<RecordListVO>
    func getUserAlgorithmRecord(limit: Int) -> Single<UserAlgorithmRecordVO>
    func postReport(id: String, message: String) -> Single<Void>
}

final class DefaultHomeRecordUseCase: HomeRecordUseCase {
    
    private let disposeBag = DisposeBag()
    private let homeRecordRepository: HomeRecordRepository
    
    // MARK: - Initializer
    init(homeRecordRepository: HomeRecordRepository) {
        self.homeRecordRepository = homeRecordRepository
    }
    
    func getHomeRecords(limit: Int, skip: Int) -> Single<RecordListVO> {
        homeRecordRepository.getRecords(limit: limit, skip: skip)
    }
    
    func getUserAlgorithmRecord(limit: Int) -> Single<UserAlgorithmRecordVO> {
        homeRecordRepository.getUserAlgorithmRecord(limit: limit)
    }
    
    func postReport(id: String, message: String) -> Single<Void> {
        homeRecordRepository.postReport(id: id, message: message)
    }
}
