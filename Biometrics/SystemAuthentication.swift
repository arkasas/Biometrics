//
//  SystemBiometrics.swift
//  Biometrics
//
//  Created by Arkadiusz Pituła on 16.05.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

public class SystemAuthentication: Biometrics {

    private struct DefaultNames {
        static let defaultName = "systemAuthName"
        static let hasLoginKey = "systemAuthHasLoginKey"
    }

    private let configuration: Configuration

    private var hasLoginKey: Bool {
        return UserDefaults.standard.bool(forKey: DefaultNames.hasLoginKey)
    }

    enum SystemAuthenticationError: Error {
        case cannotReadName
        case cannotEvaluatePolicy
        case userHasNoLoginKey
    }
    
    required public init(configuration: Configuration) {
        self.configuration = configuration
    }

    public func save(name: String, password: String) throws {
        let passwordItem = KeychainPasswordItem(service: configuration.appServiceName, account: name, accessGroup: configuration.accessGroup)

        try passwordItem.savePassword(password)
        saveName(name: name)
        saveHasLoginKey(value: true)
    }

    public func authenticate(completion: @escaping (Completion) -> Void) {
        let bioAuth = BiometricsAuthentication(reason: configuration.reason)

        if !bioAuth.canEvaluatePolicy() {
            completion(.fail(SystemAuthenticationError.cannotEvaluatePolicy))
            return
        }

        if !hasLoginKey {
            completion(.fail(SystemAuthenticationError.userHasNoLoginKey))
            return
        }

        bioAuth.authenticate { result in
            switch result {
            case .success:
                do {
                    let password = try self.getPassword()
                    completion(.success(password))
                } catch {
                    completion(.fail(error))
                }
            case .fail(let error):
                completion(.fail(error))
            }
        }
    }

    private func getName() throws -> String {
        if let name = UserDefaults.standard.string(forKey: DefaultNames.defaultName) {
            return name
        }
        throw SystemAuthenticationError.cannotReadName
    }

    private func getPassword() throws -> String {
        let name = try getName()
        let passwordItem = KeychainPasswordItem(service: configuration.appServiceName, account: name, accessGroup: configuration.accessGroup)
        let password = try passwordItem.readPassword()
        return password
    }

    private func saveName(name: String) {
        UserDefaults.standard.set(name, forKey: DefaultNames.defaultName)
    }

    private func saveHasLoginKey(value: Bool) {
        UserDefaults.standard.set(value, forKey: DefaultNames.hasLoginKey)
    }

}

