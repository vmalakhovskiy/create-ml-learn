//
//  ActivityHelper.swift
//  ActivityRecorder
//
//  Created by Dieter Kunze on 3/17/21.
//

import Foundation
import CoreML

class ActivityHelper {
    
    func isSquatting(input: Input) -> Bool {
        let activityClassificationModel = WorkoutActivityClassifier()
        var currentIndexInPredictionWindow = 0

        let accelDataX = try! MLMultiArray(shape: [input.accX] as [NSNumber], dataType: MLMultiArrayDataType.double)
        let accelDataY = try! MLMultiArray(shape: [input.accY] as [NSNumber], dataType: MLMultiArrayDataType.double)
        let accelDataZ = try! MLMultiArray(shape: [input.accZ] as [NSNumber], dataType: MLMultiArrayDataType.double)

        let gyroDataX = try! MLMultiArray(shape: [input.rotX] as [NSNumber], dataType: MLMultiArrayDataType.double)
        let gyroDataY = try! MLMultiArray(shape: [input.rotY] as [NSNumber], dataType: MLMultiArrayDataType.double)
        let gyroDataZ = try! MLMultiArray(shape: [input.rotZ] as [NSNumber], dataType: MLMultiArrayDataType.double)

        var stateOutput = try! MLMultiArray(shape:[input.stateIn as NSNumber], dataType: MLMultiArrayDataType.double)
        return false
    }
    
}
