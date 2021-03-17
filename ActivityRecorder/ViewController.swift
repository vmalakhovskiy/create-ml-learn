

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var startRecordButton: UIButton!
    @IBOutlet var stopRecordButton: UIButton!
    @IBOutlet var autoStopSwitch: UISwitch!
    @IBOutlet var activityLabel: UITextField!
    @IBOutlet var stopTimerText: UITextField!
    @IBOutlet var filesCountLabel: UILabel!
    @IBOutlet var timerHolderView: UIView!


    var motionDataRecorder: MotionDataRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordButton.isHidden = autoStopSwitch.isOn
        stopRecordButton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startRecording() {
        guard let activityName = activityLabel.text else {
            print("Error: No Activity name is given")
            return;
        }
        let recorder = MotionDataRecorder(with: activityName)
        recorder.startMotionUpdates()
        motionDataRecorder = recorder
        
        startRecordButton.isEnabled = false
        stopRecordButton.isEnabled = true
        if autoStopSwitch.isOn {
            let timertext = stopTimerText.text ?? "20"
            guard let duration = Double(timertext) else {
                print("Error: Timer value is not specified")
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.stopRecording()
            }
        }
    }
    
    @IBAction func stopRecording() {
        guard let recorder = motionDataRecorder else {
            return
        }
        recorder.stopMotionUpdates()
        startRecordButton.isEnabled = true
        stopRecordButton.isEnabled = false
        updateNumberOfFiles()
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    @IBAction func changeStopAction(_ sender: UISwitch) {
        stopRecordButton.isHidden = sender.isOn
        timerHolderView.isHidden = !sender.isOn
    }
    
    @IBAction func clearTrainingData() {
        MotionDataRecorder.clearTrainingData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.activityLabel {
            updateNumberOfFiles()
        }
    }
    
    func updateNumberOfFiles() {
        let filesCount = MotionDataRecorder.numberOfFiles(for:self.activityLabel.text ?? "unknown")
        let fileCountString = String.localizedStringWithFormat(NSLocalizedString("%d file(s)", comment: ""), filesCount)
        self.filesCountLabel.text = fileCountString
    }
}

