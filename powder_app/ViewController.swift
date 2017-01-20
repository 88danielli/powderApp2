
// this app was created by Daniel Li, Nolan lindeke, and Zack Kouba
//  ViewController.swift
//  powder_app
//
//  Created by Nolan Lindeke on 1/12/17.
//  Copyright © 2017 Nolan Lindeke. All rights reserved.
//

import UIKit
import CoreMotion
import CoreFoundation
import CoreLocation
import CoreData

class ViewController: UIViewController, CLLocationManagerDelegate, runDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var powderRuns = [PowderRunData]()


    override func viewDidLoad() {
        super.viewDidLoad()
        liftIcont.isHidden = true
        clockIcon.isHidden = true
        biffsIcon.isHidden = true
        altitudeIcon.isHidden = true
        jumpIcon.isHidden = true
        avgSpeedIcon.isHidden = true
        topSpeedIcon.isHidden = true
        newBackgroundImage.isHidden = true
        powderReportLabel.text = ""
        liftLabel.text = ""
        altitudeLabel.text = ""
        biffsLabel.text = ""
        jumpLabel.text = ""
        avgSpeedLabel.text = ""
        topSpeedLabel.text = ""
        liftLabelData.text = ""
        altitudeDataLabel.text = ""
        jumpDataLabel.text = ""
        runTimeLabel.text = ""
        runTimeDataLabel.text = ""
        avgSpeedDataLabel.text = ""
        topSpeedDataLabel.text = ""
        biffsDataLabel.text = ""
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    var biffCount = 0
    var jumpCount = 0
    var altimeterManager: CMAltimeter?
    var altitudeChange: Double = 0.0
    var rotationRate: CMMotionManager?
    
    var startTime: Date?
    var absoluteStartLocation: CLLocation?
    var absoluteEndLocation: CLLocation?
    var counter = 2
    var avgSpeedDividedBy = 0
    var manager: CLLocationManager?
    var time: Double = 0
    var speed: CLLocationSpeed = 0.0
    var distance: Double = 0
    var startLocation: CLLocation?
    var currentLocation: CLLocation?
    var count = 0
    var maxSpeed: Int = 0
    weak var timer: Timer? = nil
    
    func endTimer() {
        self.count = 0
        self.timer?.invalidate()
        self.timer = nil
    }
    
    

    @IBOutlet weak var biffsDataLabel: UILabel!
    @IBOutlet weak var topSpeedDataLabel: UILabel!
    @IBOutlet weak var avgSpeedDataLabel: UILabel!
    @IBOutlet weak var runTimeDataLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var jumpDataLabel: UILabel!
    @IBOutlet weak var altitudeDataLabel: UILabel!
    @IBOutlet weak var liftLabelData: UILabel!
    @IBOutlet weak var newBackgroundImage: UIImageView!
    @IBOutlet weak var topSpeedLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var topSpeedIcon: UIImageView!
    @IBOutlet weak var avgSpeedIcon: UIImageView!
    @IBOutlet weak var jumpLabel: UILabel!
    @IBOutlet weak var jumpIcon: UIImageView!
    @IBOutlet weak var altitudeIcon: UIImageView!
    @IBOutlet weak var powderReportLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var liftIcont: UIImageView!
    @IBOutlet weak var liftLabel: UILabel!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var startTrackingButton: UIButton!
    @IBOutlet weak var biffsIcon: UIImageView!
    @IBOutlet weak var biffsLabel: UILabel!
    @IBAction func startTrackingPressed(_ sender: UIButton) {
        count += 1
        manager = CLLocationManager()
        startTime = manager!.location!.timestamp
        if let location = manager {
            location.requestWhenInUseAuthorization()
            location.delegate = self
            location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            location.distanceFilter = 1.0
            location.startUpdatingLocation()
            startLocation = location.location
        }
        print(speed)
        print("count \(count)")
        if self.count % 2 == 1 {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
                (_) in
                self.avgSpeedDividedBy += 1
                self.time = self.time + 0.01
                var currentSpeed = self.manager!.location!.speed
                if currentSpeed >= 0 {
                    self.speed += currentSpeed
                }
                print("current speed: \(currentSpeed)")
                print("speed: \(self.speed)")
                if self.time >  0.01 {
                    self.currentLocation = self.manager?.location
                    var addDistance = self.manager!.location!.distance(from: self.startLocation!)
                    self.distance += addDistance
                    self.startLocation = self.currentLocation
                }
                else {
                    self.absoluteStartLocation = self.manager!.location
                }
                print("distance: \(self.distance)")
                if Int(self.manager!.location!.speed) > self.maxSpeed {
                    self.maxSpeed = Int(self.manager!.location!.speed / 0.4470399999)
                    self.topSpeedDataLabel.text = "\(self.maxSpeed) MPH"
                    print(self.maxSpeed)
                }
                self.runTimeDataLabel.text = String(self.time)
                self.avgSpeedDataLabel.text = String(format: "%.0f", (self.speed / 0.4470399999)/Double(self.avgSpeedDividedBy))
            }
        }
        else {
            endTimer()
            altimeterManager!.stopRelativeAltitudeUpdates()
            print(altitudeChange)
            let conversionToFeet = (altitudeChange*3.280839895) * -1
            altitudeDataLabel.text = String(format: "%.0f", conversionToFeet)+" ft"
            jumpDataLabel.text = String(self.jumpCount)
            biffsDataLabel.text = String(biffCount)
            absoluteEndLocation = manager?.location
            
//            start CoreData
            
            let newRunData = NSEntityDescription.insertNewObject(forEntityName: "PowderRunData", into: managedObjectContext) as! PowderRunData
            newRunData.biffsCount = Int64(biffCount)
            newRunData.jumpsCount = Int64(jumpCount)
            newRunData.topSpeed = Double(maxSpeed)
            newRunData.totalAltitudeDrop = Int32(conversionToFeet)
            
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                    print(newRunData)
                } catch {
                    print("\(error)")
                }
            }
//            end CoreData
            
            performSegue(withIdentifier: "runDetailsSegue", sender: self)
            
            
            
        }


        
        if counter % 2 == 0 {
            powderReportLabel.text = "Recording..."
            powderReportLabel.textColor = UIColor.red
            liftIcont.isHidden = false
            clockIcon.isHidden = false
            biffsIcon.isHidden = false
            altitudeIcon.isHidden = false
            jumpIcon.isHidden = false
            topSpeedIcon.isHidden = false
            avgSpeedIcon.isHidden = false
            newBackgroundImage.isHidden = false
            liftLabel.text = "Total Distance"
            runTimeLabel.text = "Total Time"
            altitudeLabel.text = "Altitude Drop"
            jumpLabel.text = "Total Jumps"
            avgSpeedLabel.text = "Average Speed"
            topSpeedLabel.text = "Top Speed"
            biffsLabel.text = "Total Biffs"
            liftLabelData.text = ""
            altitudeDataLabel.text = ""
            jumpDataLabel.text = "0"
            biffsDataLabel.text = "0"
            
            
            startTrackingButton.setTitle("Stop Tracking", for: .normal)
            startTrackingButton.backgroundColor = UIColor.red
        }
        if counter > 2 && counter % 2 != 0 {
            powderReportLabel.textColor = UIColor.black
            powderReportLabel.text = "Great Run!"
            startTrackingButton.setTitle("Start Tracking", for: .normal)
            startTrackingButton.backgroundColor = UIColor.green
        }
        if counter > 2 && counter % 2 == 0 {
            powderReportLabel.text = "Recording..."
            startTrackingButton.setTitle("Stop Tracking", for: .normal)
            startTrackingButton.backgroundColor = UIColor.red
        }
        counter += 1
        
//        this is daniels code
        var jumpResults = [Double]()
        altimeterManager = CMAltimeter()
        if let altimetermanager = altimeterManager {
            if CMAltimeter.isRelativeAltitudeAvailable(){
                let altimeterQ = OperationQueue()
                altimetermanager.startRelativeAltitudeUpdates(to: altimeterQ) {
                    [weak self] (altimeterData: CMAltitudeData?, error: Error?) in
                    if let altimeterdata = altimeterData {
                        let altitude = altimeterdata.relativeAltitude
                        print("Altitidue: " + String(describing: altitude))
                        self?.altitudeChange = Double(altitude)
                        jumpResults.append(Double(altitude))
                    }
                    else {
                        print("Not enough" + String(jumpResults.count))
                    }
                    if jumpResults.count > 2 {
                        let finalMeasurementPoint = jumpResults[jumpResults.count - 1]
                        let secondMeasurementPoint = jumpResults[jumpResults.count - 2]
                        if finalMeasurementPoint - secondMeasurementPoint > 0.15 {
                            self!.jumpCount += 1
                    }
                }
            }
        }
        else {
            print("No altimeter available")
        }
    }
}
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let navigationController = segue.destination as! UINavigationController
        navigationController.navigationBar.barTintColor = UIColor.blue
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let PowderReportController = navigationController.topViewController as! PowderReportViewController
        PowderReportController.delegate = self
        PowderReportController.distance = distance
        PowderReportController.absoluteStartLocation = absoluteStartLocation
        PowderReportController.absoluteEndLocation = absoluteEndLocation
        PowderReportController.speed = (self.speed / 0.4470399999)/Double(self.avgSpeedDividedBy)
        PowderReportController.jumps = jumpCount
        PowderReportController.maxSpeed = maxSpeed
        PowderReportController.altitude = (altitudeChange*3.280839895) * -1
        PowderReportController.biffs = biffCount
    }
    
    func cancelButtonPressed(by controller: PowderReportViewController) {
        dismiss(animated: true, completion: nil)
        time = 0.00
        speed = 0
        maxSpeed = 0
        distance = 0
        biffCount = 0
        jumpCount = 0
        altitudeChange = 0.0
        avgSpeedDividedBy = 0
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        biffCount += 1
    }
    
}
