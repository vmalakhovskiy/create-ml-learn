import Foundation
import CoreMotion
let sensorsUpdateInterval = 1.0 / 50.0

struct MotionData {
    let accelDataX: Double
    let accelDataY: Double
    let accelDataZ: Double
    let gyroDataX: Double
    let gyroDataY: Double
    let gyroDataZ: Double
}

class MotionDataRecorder {
    let motionManager = CMMotionManager()
    let motionDataQueue = OperationQueue()
   
    
    func startMotionUpdates(handler: @escaping (MotionData) -> ()) {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = sensorsUpdateInterval
            
            self.motionManager.startDeviceMotionUpdates(
                to: self.motionDataQueue, withHandler: { (data, error) in
                    if let validData = data {
                        let userAcceleration = validData.userAcceleration
                        let gyroData = validData.rotationRate
                        
                        let motionData = MotionData(
                            accelDataX: userAcceleration.x,
                            accelDataY: userAcceleration.y,
                            accelDataZ: userAcceleration.z,
                            gyroDataX: gyroData.x,
                            gyroDataY: gyroData.y,
                            gyroDataZ: gyroData.z
                        )

                        handler(motionData)
                    }
                })
        }
    }
    
    func stopMotionUpdates() {
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }
    }
}
