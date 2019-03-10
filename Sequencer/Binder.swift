//
//  Constants.swift
//  Sequencer
//
//  Created by Arnaldo on 3/10/19.
//  Copyright © 2019 Arnaldo. All rights reserved.
//

import Swinject

public class Binder {
    
    private lazy var container = Container()
    public static let shared = Binder()
    
    init() {
        setup()
    }
    
    func setup() {
        bind(MTIProtocol.self, to: MTI(), scope: .container)
        container.register(PlayerViewModelProtocol.self) {
            return PlayerViewModel(mti: $0.resolve(MTIProtocol.self)!)
        }
    }
}

public extension Binder {
    public func bind<T>(_ interface: T.Type, to assembly: T, scope: ObjectScope = .graph) {
        container.register(interface) { _ in assembly }.inObjectScope(scope)
    }
    public func resolve<T>(interface: T.Type) -> T! {
        return container.resolve(interface)
    }
    static func bind<T>(interface: T.Type, to assembly: T) {
        Binder.shared.bind(interface, to: assembly)
    }
    static func resolve<T>(_ interface: T.Type) -> T! {
        return Binder.shared.resolve(interface: interface)
    }
}
