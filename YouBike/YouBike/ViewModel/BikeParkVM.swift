//
//  BikeLocationViewModel.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya
import YouBikeKit

struct BikeParkVM {
    private let locations = BehaviorRelay<[BikePark]>(value: [])
}

fileprivate let api: MoyaProvider<BikeLocationAPI> = .init()
extension BikeParkVM: ViewModelType {
    
    struct Trigger {
        let fetch: Observable<Void>
    }
    
    struct Output {
        let parks: Observable<[BikePark]>
    }
    
    func convert(_ trigger: BikeParkVM.Trigger?, status: RxStatus, with bag: DisposeBag) -> BikeParkVM.Output {
        
        trigger?
            .fetch
            .flatMap{ _ -> Observable<[BikePark]> in
                return .merge(
                    api.rx.request(.list)
                        .map(BikeParkResponse.self)
                        .handle(status: status)
                        .map{ $0.retVal.map{ $0.value } },
                    .just([])
                )
            }
            .bind(to: locations)
            .disposed(by: bag)
        
        return .init(parks: locations.map{ $0 })
    }
    
    
}
