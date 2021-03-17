import UIKit
import CoreML

class ViewController: UIViewController {

    @IBOutlet var startRecordButton: UIButton!
    @IBOutlet var stopRecordButton: UIButton!

    var motionDataRecorder: MotionDataRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRecordButton.isHidden = false
        stopRecordButton.isHidden = true
    }
    
    @IBAction func startRecording() {
        let activityName = "activity"
        let recorder = MotionDataRecorder(with: activityName)
        recorder.startMotionUpdates()
        motionDataRecorder = recorder
        
        startRecordButton.isHidden = true
        stopRecordButton.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(5)) {
            self.stopRecording()
        }
    }
    
    func stopRecording() {
        guard let recorder = motionDataRecorder else {
            return
        }
        recorder.stopMotionUpdates()
        startRecordButton.isHidden = false
        stopRecordButton.isHidden = true
        
        motionDataRecorder?.stopMotionUpdates()
        
//        guard let motions = motionDataRecorder?.motions else { return }
//        let rotation_x = motions.map(\.gyroX)
//        let rotation_y = motions.map(\.gyroY)
//        let rotation_z = motions.map(\.gyroZ)
//        do {
//         let result = try model.prediction(
//            rotation_x: MLMultiArray(rotation_x), rotation_y: MLMultiArray(rotation_y),
//            rotation_z: MLMultiArray(rotation_z), stateIn: MLMultiArray([1])
//         )
//            print(result.labelProbability)
//        } catch {
//            print("error")
//         }
    }

    
    @IBAction func clearData() {
        MotionDataRecorder.clearTrainingData()
    }
}
