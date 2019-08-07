//
//  BaseCell.swift
//  YouBike
//
//  Created by LAU KIM FAI on 7/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit
import Then

class BaseCell: UITableViewCell {
    
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
}
