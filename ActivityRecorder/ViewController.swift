import UIKit

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
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    @IBAction func clearData() {
        MotionDataRecorder.clearTrainingData()
    }
}
