//
//  Input.swift
//  ActivityRecorder
//
//  Created by Dieter Kunze on 3/17/21.
//

import Foundation

class Input {
    var accX: Double
    var accY: Double
    var accZ: Double
    var rotX: Double
    var rotY: Double
    var rotZ: Double
    var stateIn: Double
    init(accX: Double, accY: Double, accZ: Double, rotX: Double, rotY: Double, rotZ: Double, stateIn: Double) {
        self.accX = accX
        self.accY = accY
        self.accZ = accZ
        self.rotX = rotX
        self.rotY = rotY
        self.rotZ = rotZ
        self.stateIn = stateIn
    }
}
