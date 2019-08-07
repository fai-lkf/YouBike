//
//  BaseVC.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import RxSwift
import RxCocoa
import Then
import SnapKit

class BaseVC: UIViewController {
    
    lazy var bag = DisposeBag()
    var isProcessing: [Driver<Bool>] { get { return [] } }
    
    private lazy var indicator = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
        
        indicator.do{
            view.addSubview($0)
            $0.snp.updateConstraints{
                $0.center.equalToSuperview()
            }
            
            Driver
                .combineLatest(isProcessing)
                .map{ $0.contains(true) }
                .drive($0.rx.isAnimating)
                .disposed(by: bag)
        }
    }
    
    func setupUI() {}
    func setupRX() {}
    
}
