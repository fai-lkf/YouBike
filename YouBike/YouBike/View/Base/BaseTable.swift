//
//  BaseTable.swift
//  YouBike
//
//  Created by LAU KIM FAI on 7/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import UIKit
import Then
import RxSwift
import RxCocoa

class BaseTable: UITableView {
    
    private lazy var control = UIRefreshControl()
    private lazy var bag = DisposeBag()
    
    let refresh = PublishRelay<Void>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        control.do{
            addSubview($0)
            $0.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        }
        
        separatorStyle = .none
        
        rx.methodInvoked(#selector(dequeueReusableCell(withIdentifier:)))
            .map{ _ in false }
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: control.rx.isRefreshing)
            .disposed(by: bag)
    }
    
    @objc private func pullToRefresh() {
        refresh.accept(())
    }
    
}
