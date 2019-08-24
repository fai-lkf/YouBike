//
//  SequenceX.swift
//  YouBike
//
//  Created by LAU KIM FAI on 7/8/2019.
//  Copyright © 2019 Ricky Lau. All rights reserved.
//


extension Sequence {
    typealias E = Iterator.Element
    
    func group<U: Hashable>(_ key: (E) -> U) -> [U: [E]] {
        return Dictionary(grouping: self, by: key)
    }
    
    func distinct<U: Hashable>(_ predicate: (E) -> U) -> [E] {
        return group(predicate).compactMap{ $0.value.first }
    }
}

extension Sequence where Element: Hashable {
    public func unique() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    public func set() -> Set<Element> { return .init(self) }
}

extension Array where Element: Hashable {
    public func insertOrRemove(_ target: Element) -> [Element] {
        var result = self
        if let index = result.firstIndex(of: target) {
            result.remove(at: index)
        } else {
            result.append(target)
        }
        return result
    }
}
