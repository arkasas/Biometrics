//
//  BiometricsAuthentication.swift
//  Biometrics
//
//  Created by Arkadiusz Pituła on 16.05.2018.
//  Copyright © 2018 Arkadiusz Pituła. All rights reserved.
//

import LocalAuthentication

class BiometricsAuthentication {
    enum BiometricType {
        case none
        case touchId
        case faceId
    }

    enum AuthenticationError: Error {
        case cannotEvaluate
    }

    enum Result {
        case success
        case fail(Error)
    }

    var type: BiometricType {
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        if #available(iOS 11.0.1, *) {
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchId
            case .faceID:
                return .faceId
            }
        } else {
            return .touchId
        }
    }

    private let context = LAContext()
    private let reason: String

    init(reason: String) {
        self.reason = reason
    }

    func canEvaluatePolicy() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }

    func clear() {
        context.invalidate()
    }

    func authenticate(result: @escaping (Result) -> Void) {
        guard canEvaluatePolicy() else {
            result(.fail(AuthenticationError.cannotEvaluate))
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, error) in
            if success {
                DispatchQueue.main.async {
                    result(.success)
                }
            } else {
                if let error = error {
                    result(.fail(error))
                }
            }
        }

    }


}
