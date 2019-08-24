//
//  RxStatus.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import RxSwift
import RxCocoa
import RxOptional
import Moya

enum ObservableEvent {
    case subscribe(UUID)
    case clear(UUID)
    
    case error(UUID, Error)
}

struct UUIDError {
    let uuid: UUID
    let error: Error
}

class RxStatus {
    
    private let processing = BehaviorRelay<Set<UUID>>(value: [])
    private let error = BehaviorRelay<[UUIDError]>(value: [])
    
    let onEvent = PublishRelay<ObservableEvent>()
    var isProcessing: Driver<Bool> {
        return processing.map{ $0.isNotEmpty }.asDriver(onErrorJustReturn: false)
    }
    
    private lazy var bag = DisposeBag()
    
    init() {
        
        onEvent
            .withLatestFrom(processing) { ($0, $1) }
            .map{ event, all -> Set<UUID> in
                var result = all
                switch event {
                case .clear(let uuid), .error(let uuid, _):
                    result.remove(uuid)
                case .subscribe(let uuid):
                    result.insert(uuid)
                }
                return result
            }
            .bind(to: processing)
            .disposed(by: bag)
        
        onEvent
            .map{ event -> UUIDError? in
                switch event {
                case .error(let uuid, let error):
                    return .init(uuid: uuid, error: error)
                default:
                    return nil
                }
            }
            .filterNil()
            .withLatestFrom(error) { $1 + [$0] }
            .bind(to: error)
            .disposed(by: bag)
        
        error
            .map{ $0.first }
            .filterNil()
            .flatMap{ target -> Observable<UUID> in
                guard let root = UIApplication.shared.delegate?.window??.rootViewController else { return .empty() }
                return Observable<UUID>.create{ observer in
                    let alert = UIAlertController(title: "Error", message: target.error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default) { _ in
                        observer.onNext(target.uuid)
                        observer.onCompleted()
                        })
                    root.present(alert, animated: true)
                    return Disposables.create()
                }
            }
            .withLatestFrom(error) { shown, all -> [UUIDError] in
                var result = all
                result.removeAll(where: { $0.uuid == shown })
                return result
            }
            .bind(to: error)
            .disposed(by: bag)
        
    }
}

extension ObservableType {
    func handle(status: RxStatus) -> Observable<Element> {
        let uuid = UUID()
        return self
            .do(onError: {
                status.onEvent.accept(.error(uuid, $0))
            }, onCompleted: {
                status.onEvent.accept(.clear(uuid))
            }, onSubscribed: {
                status.onEvent.accept(.subscribe(uuid))
            }, onDispose: {
                status.onEvent.accept(.clear(uuid))
            })
            .catchError{ _ in .empty() }
    }
}

extension PrimitiveSequence {
    func handle(status: RxStatus) -> Observable<Element> {
        return asObservable().handle(status: status)
    }
}
