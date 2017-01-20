//
//  allRunsTableViewController.swift
//  powder_app
//
//  Created by Daniel Li on 1/20/17.
//  Copyright © 2017 Nolan Lindeke. All rights reserved.
//

import UIKit
import CoreData

class allRunsTableViewController: UITableViewController {
    
    var powderRuns = [PowderRunData]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllPowderRuns()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return powderRuns.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Elevation Change: " + String(powderRuns[indexPath.row].totalAltitudeDrop) + " Top Speed: " + String(powderRuns[indexPath.row].topSpeed) + " Biffs: " + String(powderRuns[indexPath.row].biffsCount) + " Jumps: " + String(powderRuns[indexPath.row].jumpsCount)
        return cell
    }
    
    func fetchAllPowderRuns() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PowderRunData")
        do {
            let result = try managedObjectContext.fetch(request)
            powderRuns = result as! [PowderRunData]
        }
        catch {
            print("\(error)")
        }
    }
    
}
