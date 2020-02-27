//
//  Notification.swift
//  MusicApp
//
//  Created by Vadim on 27/02/2020.
//  Copyright © 2020 Vadim Mezentsev. All rights reserved.
//

import Foundation

class NotificationManager<Observer> {
    
    private var observers = NSMutableSet()
    
    func addObserver(_ observer: Observer) {
        observers.add(observer)
    }
    
    func removeObserver(_ observer: Observer) {
        observers.remove(observer)
    }
    
    func notify(_ event: (Observer) -> Void) {
        observers.forEach { (element) in
            guard let observer = element as? Observer else { return }
            event(observer)
        }
    }
}
