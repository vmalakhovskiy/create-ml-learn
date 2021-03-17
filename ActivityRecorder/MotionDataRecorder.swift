import Foundation
import CoreMotion
let sensorsUpdateInterval = 1.0 / 50.0

struct MotionData {
    let gyroX: Double
    let gyroY: Double
    let gyroZ: Double
}

class MotionDataRecorder {
    var motions = [MotionData]()
    let motionManager = CMMotionManager()
    let motionDataQueue = OperationQueue()
    let header = "rotation_x,rotation_y,rotation_z,acceleration_x,acceleration_y,acceleration_z\n"
    var csvWriter:CSVFileWriter?
    var activityName  = "unknown"
    var fileName = "\(Date().timeIntervalSince1970)"
    init(with activityName: String) {
        // Serial queue for sample handling and calculations.
        motionDataQueue.maxConcurrentOperationCount = 1
        motionDataQueue.name = "MotionManagerQueue"
        self.activityName = activityName
        self.fileName = "\(self.activityName)_\(Date().timeIntervalSince1970)"
    }
    
    func startMotionUpdates() {
        

        
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = sensorsUpdateInterval
            csvWriter = CSVFileWriter(with: csvFileURL(), header: header)
            self.motionManager.startDeviceMotionUpdates(
                to: self.motionDataQueue, withHandler: { (data, error) in
                    // Make sure the data is valid before accessing it.
                    if let validData = data {
                        // Get the attitude relative to the magnetic north reference frame.
                        let userAcceleration = validData.userAcceleration
                        let gyroData = validData.rotationRate
                        let csvString = "\(gyroData.x),\(gyroData.y),\(gyroData.z),\(userAcceleration.x),\(userAcceleration.y),\(userAcceleration.z)\n"
                        
                        let motionData = MotionData(gyroX: gyroData.x, gyroY: gyroData.y, gyroZ: gyroData.z)
                        self.motions.append(motionData)
                        
                        print(csvString)
                        // Use the motion data in your app.
                        guard let fileWriter = self.csvWriter else {
                            return
                        }
                        fileWriter.append(csvString)
                    }
                })
        }
    }
    
    func stopMotionUpdates() {
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
            guard let fileWriter = self.csvWriter else {
                return
            }
            fileWriter.close()
        }
    }
    
    
    func csvFileURL() -> URL {
        let trainingFolderPath = MotionDataRecorder.trainingFolderURL().appendingPathComponent(self.activityName)
        if FileManager.default.fileExists(atPath: trainingFolderPath.path) == false {
            do
            {
                try FileManager.default.createDirectory(atPath: trainingFolderPath.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error as NSError
            {
                print("Unable to create directory \(error.debugDescription)")
            }
            
        }
        let csvFileName = trainingFolderPath.appendingPathComponent("\(self.fileName).csv")
        return csvFileName
    }
    
    class func trainingFolderURL() -> URL {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let trainingFolderURL = documentPath.appendingPathComponent("Training")
        
        return trainingFolderURL
    }
    
    class func numberOfFiles(for activity:String) ->Int {
        let trainingFolderPath = MotionDataRecorder.trainingFolderURL().appendingPathComponent(activity)
        if FileManager.default.fileExists(atPath: trainingFolderPath.path) {
            let directoryContents = try! FileManager.default.contentsOfDirectory(at: trainingFolderPath, includingPropertiesForKeys: nil)
            return directoryContents.count
        } else {
            return 0
        }
    }
    
    class func clearTrainingData(){
        let trainingFolderPath = MotionDataRecorder.trainingFolderURL()
        do {
            try FileManager.default.removeItem(at: trainingFolderPath)
        }catch {
            print("Error: Failed to clear the training data")
        }

    }
}
