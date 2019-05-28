//
//  ScoreTableViewController.swift
//  FinalWork
//
//  Created by alu on 2019/5/25.
//  Copyright © 2019年 alu. All rights reserved.
//

import UIKit
import CoreData

class ScoreTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    private static let scoreCellIdentifier = "ScoreTableViewCell"
    
    private static let ScoreEntityName = "Score"
    private static let courseKey = "course"
    private static let snameKey = "sname"
    private static let scoreKey = "score"
    
    var scoreDetail: [String: Double]! = [:]
    var courses:[String]! = []
    @IBOutlet var tableView: UITableView!
   
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func selectBtnPressed(_ sender: UIButton) {
        scoreDetail.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: ScoreTableViewController.ScoreEntityName)
        let pred = NSPredicate(format: "sname = '" + nameTextField.text! + "'")
        request.predicate = pred
        
        do {
            let objects = try context.fetch(request)
            for object in objects{
                let course = (object as AnyObject).value(forKey: ScoreTableViewController.courseKey) as? String ?? ""
                let score = (object as AnyObject).value(forKey: ScoreTableViewController.scoreKey) as? Double
                scoreDetail[course] = score
                courses.append(course)
            }
        } catch {
            print("error: " + "\(error)")
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //AddScores()
        tableView.register(ScoreTableViewCell.self, forCellReuseIdentifier: ScoreTableViewController.scoreCellIdentifier)
        let xib = UINib(nibName:"ScoreTableViewCell",bundle:nil)
        tableView.register(xib, forCellReuseIdentifier: ScoreTableViewController.scoreCellIdentifier)
        tableView.rowHeight = 67
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreDetail.count
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreTableViewCell", for: indexPath) as! ScoreTableViewCell
        cell.courseLabel.text = courses[indexPath.row]
        cell.scoreLabel.text = String(describing: scoreDetail[courses[indexPath.row]]!)
        return cell
    }
    
    func AddScores(){
        scoreDetail = ["c#":92, "java": 88, "javaExp":96, "data structure":99, "badminton":96]
        courses = ["c#", "java", "javaExp", "data structure", "badminton"]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        do {
            
            var theLine: NSManagedObject!
            
            for i in 0..<5{
                theLine = NSEntityDescription.insertNewObject(forEntityName: ScoreTableViewController.ScoreEntityName, into: context) as NSManagedObject
                theLine.setValue("Alu", forKey: ScoreTableViewController.snameKey)
                theLine.setValue(courses[i], forKey: ScoreTableViewController.courseKey)
                theLine.setValue(scoreDetail[courses[i]], forKey: ScoreTableViewController.scoreKey)
            }
        } catch {
            print("error: " + "\(error)")
        }
        appDelegate.saveContext()
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
