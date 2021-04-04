//
//  AppError.swift
//  Orchestra
//
//  Created by Ramzy Kermad on 04/04/2021.
//

import Foundation

enum AppError: Error {

    case validation,
    invalidCredentials

    var displayText: String {
        switch self {
        case .validation:
            return "Validation error"
        case .invalidCredentials:
            return "Invalid credentials"
        }
    }

}
