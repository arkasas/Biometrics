//
//  Configuration.swift
//  Biometrics
//
//  Created by Arkadiusz Pituła on 16.05.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

@objc protocol Configuration {
    var reason: String { get }
    var appServiceName: String { get }
    @objc optional var accessGroup: String { get }
}
