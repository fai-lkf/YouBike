//
//  UIX.swift
//  YouBike
//
//  Created by LAU KIM FAI on 6/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

extension NSObject: Namable {}

extension UIViewController {
    static func xib() -> Self { return self.init(nibName: name, bundle: nil) }
}

extension UIResponder {
    static func nib() -> UINib { return UINib(nibName: name, bundle: nil) }
}

extension CGColor {
    var uiColor: UIColor { return UIColor(cgColor: self) }
}

extension UITableView {
    func regsiter(nib cell: UITableViewCell.Type) {
        register(cell.nib(), forCellReuseIdentifier: cell.name)
    }
    
    func regsiter(class cell: UITableViewCell.Type) {
        register(cell, forCellReuseIdentifier: cell.name)
    }
    
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: T.name, for: indexPath) as! T
    }
}

extension Reactive where Base: UIView {
    var onTap: Observable<Void> {
        return tapGesture()
            .when(.recognized)
            .map{ _ in () }
    }
}

extension Reactive where Base: UIImageView {
    var tintColor: Binder<UIColor?> {
        return Binder(base) { iv, tint in
            iv.tintColor = tint
        }
    }
}

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get { return layer.borderColor?.uiColor }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get { return layer.shadowColor?.uiColor }
        set { layer.shadowColor = newValue?.cgColor }
    }
}
