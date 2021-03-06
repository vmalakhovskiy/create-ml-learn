import UIKit
import CoreML

class ViewController: UIViewController {

    @IBOutlet var startRecordButton: UIButton!
    @IBOutlet var blackLabel: UILabel!
    @IBOutlet var grayLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    var counter = 0
    var updated = false
    
    let motionDataRecorder = MotionDataRecorder()
    let model = try! WorkoutActivityClassifierV2(configuration: MLModelConfiguration())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countLabel.isHidden = true
        startRecordButton.layer.cornerRadius = 30
    }
    
    var lastAction: String?
    
    func enumerateSquat(action: String) -> Bool {
        if let lastAction = lastAction {
            if(lastAction != "squats" || lastAction != "lunge") {
                if(action == "squats" || action == "lunge") {
                    return true
                }
            }
        }
        return false
    }
    
    @IBAction func startRecording() {
        let stateInLength = 400
        var stateOutput = try! MLMultiArray(shape:[stateInLength as NSNumber], dataType: .double)
        
        if motionDataRecorder.recoring {
            motionDataRecorder.stopMotionUpdates()
            startRecordButton.setTitle("begin squating", for: .normal)
            blackLabel.text = "let's start again"
            grayLabel.text = "do squats."
            counter = 0
            countLabel.text = ""
            startRecordButton.backgroundColor = .label
            countLabel.isHidden = true
        } else {
            motionDataRecorder.startMotionUpdates { [weak self] data in
                guard let strongSelf = self else { return }
                
                let modelPrediction = try! strongSelf.model.prediction(
                    acceleration_x: data.accelDataX,
                    acceleration_y: data.accelDataY,
                    acceleration_z: data.accelDataZ,
                    rotation_x: data.rotationDataX,
                    rotation_y: data.rotationDataY,
                    rotation_z: data.rotationDataZ,
                    stateIn: stateOutput
                )
                
                //shsould be returned to MotionDataRecorder
                stateOutput = modelPrediction.stateOut
                
                print(modelPrediction.label)
                
                
                DispatchQueue.main.async {
                    if self?.enumerateSquat(action: modelPrediction.label) == true {
                        if self?.updated == true {
                            return
                        }
                        self?.updated = true
                        self?.counter += 1
                        
                        if self?.counter == 1 {
                            self?.countLabel.text = "uno squat ????"
                        } else if self?.counter == 2  {
                            self?.countLabel.text = "dos squatos ????????????????"
                        } else if self!.counter < 10 {
                            self?.countLabel.text = String(self!.counter) + " squats"
                        } else {
                            self?.countLabel.text = String(self!.counter) + " squats ????"
                        }
                        
                        self?.blackLabel.text = "great, that was a squat"
                        self?.grayLabel.text = "do one more."
                    } else {
                        self?.updated = false
                        self?.blackLabel.text = "what was that..."
                        self?.grayLabel.text = "you are supposed to do squats, stop " + modelPrediction.label + "."
                    }
                    
                    self?.lastAction = modelPrediction.label
                    
                    self?.view.layoutIfNeeded()
                }
            }
            startRecordButton.setTitle("i can't do any more", for: .normal)
            startRecordButton.backgroundColor = .red
            countLabel.isHidden = false
        }
    }
    
    @IBAction func clearData() {
//        MotionDataRecorder.clearTrainingData()
    }
}
