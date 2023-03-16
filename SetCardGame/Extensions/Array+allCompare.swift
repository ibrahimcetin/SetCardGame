//
//  Array+allCompare.swift
//  SetCardGame
//
//  Created by İbrahim Çetin on 16.03.2023.
//

import Foundation

extension Array where Element == Card {
    enum ComparisonResult {
        case allSame
        case allDifferent
        case none

        static prefix func !(result: ComparisonResult) -> ComparisonResult {
            switch result {
            case .allSame:
                return .allDifferent
            case .allDifferent:
                return .allSame
            case .none:
                return .none
            }
        }
    }

    func allCompare<T: Equatable>(_ featureKeyPath: KeyPath<Element, T>) -> ComparisonResult {
        var results = [Bool]()

        for item in self {
            for otherItem in self {
                if item[keyPath: featureKeyPath] != otherItem[keyPath: featureKeyPath] {
                    results.append(false)
                }
            }
        }

        if results.count / 2 == self.count {
            return .allDifferent
        } else if results.contains(false) {
            return .none
        } else {
            return .allSame
        }
    }
}
