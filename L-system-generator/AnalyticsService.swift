//
//  AnalyticsService.swift
//  L-system-generator
//
//  Created by André Schueda on 11/12/21.
//

import Foundation
import Firebase
import FirebaseCrashlytics

protocol AnalyticsService {
    func log(message: String)
    func log(key: String, value: String)
    func log(key: String, value: Int)
    func log(event: AnalyticsEvent)
}

class DefaultAnalyticsService: AnalyticsService {
    static let shared = DefaultAnalyticsService()
    
    private init() {
    }
    
    func log(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    func log(key: String, value: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    func log(key: String, value: Int) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    func log(event: AnalyticsEvent) {
        Analytics.logEvent( event.name, parameters: event.parameterAsDict)
    }
}


enum AnalyticsEvent {
    case customized(field: String)
    case randomized(field: String)
    case changedIterations(_: Int)
    case changedAngle(_: Int)
    case changedBackgroundColor(_: String)
    case changedLineColor(_: String)
    
    case savedArt(_: Art)
    case exported(media: String)
    
    case editedArt(_: Art)
    case deletedArt(_: Art)
    
    var name: String {
        switch self {
        case .customized(field: _):
            return "costumized_field"
        case .randomized(field: _):
            return "randomized_field"
        case .changedIterations(_):
            return "changed_iterations"
        case .changedAngle(_):
            return "changed_angle"
        case .changedBackgroundColor:
            return "changed_background_color"
        case .changedLineColor:
            return "changed_line_color"
        case .savedArt(_):
            return "saved_art"
        case .exported(media: let media):
            return "exported_\(media)"
        case .editedArt(_):
            return "edited_art"
        case .deletedArt(_):
            return "deleted_art"
        }
        
    }
    
    var parameterAsDict: [String: NSObject] {
        switch self {
        case .customized(field: let field):
            return [name: field as NSString]
        case .randomized(field: let field):
            return [name: field as NSString]
        case .changedIterations(let iterations):
            return [name: iterations as NSNumber]
        case .changedAngle(let angle):
            return [name: angle as NSNumber]
        case .changedBackgroundColor(let color):
            return [name: color as NSString]
        case .changedLineColor(let color):
            return [name: color as NSString]
        case .savedArt(let art):
            return [name: art.debugDescription as NSString]
        case .exported(media: _):
            return [:]
        case .editedArt(let art):
            return [name: art.debugDescription as NSString]
        case .deletedArt(let art):
            return [name: art.debugDescription as NSString]
        }
    }
}

