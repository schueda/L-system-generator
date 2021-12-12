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
    
    case savedArt(art: Art)
    case exported(media: String)
    
    case editedArt(art: Art)
    
    var name: String {
        switch self {
        case .customized(field: _):
            return "costumized field"
        case .randomized(field: _):
            return "randomized field"
        case .changedIterations(_):
            return "changediterations"
        case .changedAngle(_):
            return "changed angle"
        case .changedBackgroundColor:
            return "changed background color"
        case .changedLineColor:
            return "changed line color"
        case .savedArt(art: _):
            return "saved art"
        case .exported(media: let media):
            return "exported \(media)"
        case .editedArt(art: _):
            return "edited art"
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
        case .savedArt(art: let art):
            return [name: art as! NSObject]
        case .exported(media: _):
            return [:]
        case .editedArt(art: _):
            return [:]
        }
    }
}

