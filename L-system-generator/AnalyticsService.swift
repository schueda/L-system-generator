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
//        Analytics.logEvent(<#T##name: String##String#>, parameters: <#T##[String : Any]?#>)
    }
}


enum AnalyticsEvent {
    case customized(field: String) //
    case randomized(field: String) //
    case changed(iterations: Int) //
    case changed(angle: Int) //
    case changedBackgroundColor //
    case changedLineColor //
    
    case savedArt(art: Art) //
    case exported(media: String) //
    
    case editedArt(art: Art) //
}
