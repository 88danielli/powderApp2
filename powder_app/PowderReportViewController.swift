//
//  PowderReportViewController.swift
//  powder_app
//
//  Created by Zachary Kouba on 1/19/17.
//  Copyright © 2017 Nolan Lindeke. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PowderReportViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    weak var delegate: runDelegate?
    var distance: Double?
    var absoluteStartLocation: CLLocation?
    var absoluteEndLocation: CLLocation?
    var speed: Double?
    var jumps: Int?
    var altitude: Double?
    var maxSpeed: Int?
    var biffs: Int?
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var maxSpeedLabel: UILabel!
    @IBOutlet weak var avgSpeedLabel: UILabel!
    @IBOutlet weak var jumpsLabel: UILabel!
    @IBOutlet weak var biffsLabel: UILabel!
    
    
    
    
    
    
    @IBOutlet weak var runMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distanceLabel.text = "Distance Traveled: " + String(format: "%.0f", distance!)
        altitudeLabel.text = "Altitude Drop: " + String(format: "%.0f", altitude!)
        maxSpeedLabel.text = "Max Speed: " + String(format: "%.0f", maxSpeed!)
        avgSpeedLabel.text = "AVG Speed: " + String(format: "%.0f", speed!)
        jumpsLabel.text = "Jumps: \(jumps!)"
        biffsLabel.text = "Biffs: \(biffs!)"
        
        runMap.delegate = self
        print(absoluteStartLocation!.coordinate)
        print(absoluteEndLocation!)
        let sourceLocation = absoluteStartLocation!.coordinate
        let destinationLocation = absoluteEndLocation!.coordinate
        
        
        
        // Map info 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.runMap.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .any
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.runMap.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.runMap.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
    
    


    
}



