//
//  ParkBookmarkVM.swift
//  YouBike
//
//  Created by LAU KIM FAI on 7/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import RxSwift
import RxCocoa

struct ParkBookmarkVM {
    private let bookmark = BehaviorRelay<[String]>(value: UserDefaults.standard.stringArray(forKey: UDKey.bookmark.key) ?? [])
}

extension ParkBookmarkVM: ViewModelType {
    
    static let shared: ViewModel<ParkBookmarkVM> = .init(.init())
    
    struct Trigger {
        let adjust: Observable<String>
    }
    
    struct Output {
        let bookmarked: Observable<[String]>
    }
    
    func convert(_ trigger: ParkBookmarkVM.Trigger?, status: RxStatus, with bag: DisposeBag) -> ParkBookmarkVM.Output {
        
        trigger?.adjust
            .withLatestFrom(bookmark) { $1.insertOrRemove($0) }
            .do(onNext: { UserDefaults.standard.set($0, forKey: UDKey.bookmark.key) })
            .bind(to: bookmark)
            .disposed(by: bag)
        
        return .init(bookmarked: bookmark.asObservable())
    }
    
}
