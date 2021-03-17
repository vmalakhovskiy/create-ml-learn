import Foundation
import CoreMotion
import CoreML
let sensorsUpdateInterval = 1.0 / 50.0

struct MotionData {
    let accelDataX: MLMultiArray
    let accelDataY: MLMultiArray
    let accelDataZ: MLMultiArray
    let rotationDataX: MLMultiArray
    let rotationDataY: MLMultiArray
    let rotationDataZ: MLMultiArray
    let stateOutput: MLMultiArray
}

class MotionDataRecorder {
    
    struct ModelConstants {
        static let predictionWindowSize = 30
        static let sensorsUpdateInterval = 1.0 / 50.0
        static let stateInLength = 400
    }
    
    let motionManager = CMMotionManager()
    let motionDataQueue = OperationQueue()
    var recoring = false
    
    init() {
        motionManager.accelerometerUpdateInterval = TimeInterval(ModelConstants.sensorsUpdateInterval)
        motionManager.gyroUpdateInterval = TimeInterval(ModelConstants.sensorsUpdateInterval)
        
    }
    
    func startMotionUpdates(handler: @escaping (MotionData) -> ()) {
        if motionManager.isDeviceMotionAvailable {
            recoring = true
            
            var currentIndexInPredictionWindow = 0
            
            let accelDataX = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
            let accelDataY = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
            let accelDataZ = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
            
            let rotationDataX = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
            let rotationDataY = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
            let rotationDataZ = try! MLMultiArray(shape: [ModelConstants.predictionWindowSize] as [NSNumber], dataType: MLMultiArrayDataType.double)
            
            var stateOutput = try! MLMultiArray(shape:[ModelConstants.stateInLength as NSNumber], dataType: MLMultiArrayDataType.double)
            
            self.motionManager.deviceMotionUpdateInterval = sensorsUpdateInterval
            
            self.motionManager.startDeviceMotionUpdates(
                to: self.motionDataQueue, withHandler: { (data, error) in
                    if let validData = data {
                        let userAcceleration = validData.userAcceleration
                        let rotationData = validData.rotationRate
                        
                        accelDataX[[currentIndexInPredictionWindow] as [NSNumber]] = userAcceleration.x as NSNumber
                        accelDataY[[currentIndexInPredictionWindow] as [NSNumber]] = userAcceleration.y as NSNumber
                        accelDataZ[[currentIndexInPredictionWindow] as [NSNumber]] = userAcceleration.z as NSNumber
                        
                        rotationDataX[[currentIndexInPredictionWindow] as [NSNumber]] = rotationData.x as NSNumber
                        rotationDataY[[currentIndexInPredictionWindow] as [NSNumber]] = rotationData.y as NSNumber
                        rotationDataZ[[currentIndexInPredictionWindow] as [NSNumber]] = rotationData.z as NSNumber
                        
                        currentIndexInPredictionWindow += 1
                        
                        if (currentIndexInPredictionWindow == ModelConstants.predictionWindowSize) {
                            handler(
                                MotionData(
                                    accelDataX: accelDataX,
                                    accelDataY: accelDataY,
                                    accelDataZ: accelDataZ,
                                    rotationDataX: rotationDataX,
                                    rotationDataY: rotationDataY,
                                    rotationDataZ: rotationDataZ,
                                    stateOutput: stateOutput
                                )
                            )
                            currentIndexInPredictionWindow = 0
                        }
                    }
                })
        }
    }
    
    func stopMotionUpdates() {
        if motionManager.isDeviceMotionActive {
            recoring = false
            motionManager.stopDeviceMotionUpdates()
        }
    }
}
