import UIKit
import CoreML

class ViewController: UIViewController {

    @IBOutlet var startRecordButton: UIButton!
    @IBOutlet var stopRecordButton: UIButton!

    let motionDataRecorder = MotionDataRecorder()
//    let model = WorkoutActivityClassifier()
    
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
            motionDataRecorder.startMotionUpdates { data in
                print(data)
            }
            startRecordButton.titleLabel?.text = "stop squatting"
        }
    }
    
    @IBAction func clearData() {
//        MotionDataRecorder.clearTrainingData()
    }
}
