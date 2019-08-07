//
//  BikeParkCell.swift
//  YouBike
//
//  Created by LAU KIM FAI on 7/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BikeParkCell: BaseCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var vStatus: UIView!
    @IBOutlet weak var lblOccupancy: UILabel!
    @IBOutlet weak var lblAvailability: UILabel!
    @IBOutlet weak var lblLastUpdate: UILabel!
    @IBOutlet weak var imgStar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgStar.do{
            $0.image = imgStar.image?.withRenderingMode(.alwaysTemplate)
            $0.transform = .init(rotationAngle: .pi / 2)
        }
    }
    
    private var model: BikePark? {
        didSet {
            guard let park = model else { return }
            
            lblName.text = park.sna
            lblAddress.text = park.ar
            lblTotal.text = "停車格: \(park.total)"
            lblLastUpdate.text = "最後更新於: \(park.lastFetch.yyyy_MM_dd_HH_mm)"
            
            vStatus.isHidden = park.total == 0
            guard park.total != 0 else { return }
            
            lblOccupancy.do{
                $0.text = "\(park.occupancy) 已佔用"
                let occupied = (park.occupancy.d / park.total.d).rounded(2)
                $0.snp.remakeConstraints{
                    $0.width.equalToSuperview().multipliedBy(occupied)
                }
            }
            lblAvailability.text = "\(park.availability) 可用"
        }
    }
    
    func set(_ park: BikePark, selection: PublishRelay<String>, bookmark: Observable<[String]>) {
        model = park
        
        imgStar.rx.onTap
            .map{ park.sno }
            .bind(to: selection)
            .disposed(by: bag)
        
        bookmark
            .map{ $0.contains(park.sno) ? UIColor.blue : .gray }
            .bind(to: imgStar.rx.tintColor)
            .disposed(by: bag)
    }
    
}
