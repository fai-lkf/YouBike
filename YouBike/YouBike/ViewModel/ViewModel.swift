//
//  ViewModel.swift
//  YouBike
//
//  Created by LAU KIM FAI on 5/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional

final class ViewModel<V: ViewModelType> {
    
    let vm: V
    init(_ vm: V) {
        self.vm = vm
    }
    
    private lazy var status: RxStatus = .init()
    var isProcessing: Driver<Bool> { return status.isProcessing }
    private lazy var bag = DisposeBag()
    
    func observe(_ trigger: V.Trigger?) -> V.Output {
        return vm.convert(trigger, status: status, with: bag)
    }
    
    func prompt(error: Error) {
        status.onEvent.accept(.error(UUID(), error))
    }
    
    var error: Binder<Error> {
        return Binder(self) { vm, err in
            vm.prompt(error: err)
        }
    }
}

protocol ViewModelType {
    associatedtype Trigger
    associatedtype Output
    func convert(_ trigger: Trigger?, status: RxStatus, with bag: DisposeBag) -> Output
}
