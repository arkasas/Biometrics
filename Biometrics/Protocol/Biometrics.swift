//
//  Biometrics.swift
//  Biometrics
//
//  Created by Arkadiusz Pituła on 16.05.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

public enum Completion {
    case success(String)
    case fail(Error)
}

protocol Biometrics {
    init(configuration: Configuration)
    func save(name: String, password: String) throws
    func authenticate(completion: @escaping (Completion) -> Void)
}
