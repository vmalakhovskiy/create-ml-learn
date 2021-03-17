import UIKit
import CoreML

class ViewController: UIViewController {

    @IBOutlet var startRecordButton: UIButton!
    @IBOutlet var stopRecordButton: UIButton!

    let motionDataRecorder = MotionDataRecorder()
    let model = try! WorkoutActivityClassifier(configuration: MLModelConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startRecordButton.isHidden = false
        stopRecordButton.isHidden = true
    }
    
    @IBAction func startRecording() {
        if motionDataRecorder.recoring {
            motionDataRecorder.stopMotionUpdates()
            startRecordButton.titleLabel?.text = "begin squating"
        } else {
            motionDataRecorder.startMotionUpdates { [weak self] data in
                guard let strongSelf = self else { return }
                print()
                
                let modelPrediction = try! strongSelf.model.prediction(
                    acceleration_x: data.accelDataX,
                    acceleration_y: data.accelDataY,
                    acceleration_z: data.accelDataZ,
                    rotation_x: data.rotationDataX,
                    rotation_y: data.rotationDataY,
                    rotation_z: data.rotationDataZ,
                    stateIn: data.stateOutput
                )
                
                //shsould be returned to MotionDataRecorder
                let output = modelPrediction.stateOut
                
                print(modelPrediction.label)

            }
            startRecordButton.titleLabel?.text = "stop squatting"
        }
    }
    
    @IBAction func clearData() {
//        MotionDataRecorder.clearTrainingData()
    }
}
