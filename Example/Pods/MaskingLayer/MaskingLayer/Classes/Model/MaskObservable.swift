//
//  MaskObservable.swift
//  MaskingLayer
//
//  Created by 永田大祐 on 2019/11/01.
//

import Foundation

final class MaskObservable<ObservedType> {

    typealias Observer = (_ observable: ObservedType) -> ()

    var value: ObservedType? {
        didSet {
            guard value.debugDescription.contains(oldValue.debugDescription) else {
                if let value = value { notifyObservers(value) }
                return
            }
        }
    }

    func initValue() { value = nil }

    func bind(observer: @escaping Observer) { self.observers.append(observer) }

    private var observers: [Observer] = []

    private func notifyObservers(_ value: ObservedType) { self.observers.forEach { observer in observer(value) }

    }
}
