//
//  StuInfoTableViewController.swift
//  FinalWork
//
//  Created by alu on 2019/5/24.
//  Copyright © 2019年 alu. All rights reserved.
//

import UIKit
import CoreData

class StuInfoTableViewController: UITableViewController, SearchCellSelectDelegate {

    let stuInfoTableIdentifier = "StuInfoTableIdentifier"
    var stuNames: [String]! = []
    var students: [String:String] = [:]
    var snos: [String]! = []
    
    var searchController: UISearchController!
    var filterNames: [String]!
    var stuInfoSearchResultsTableViewController = UISearchController()
    var searchBar: UISearchBar!
    
    private static let stuInfoEntity = "StuInfo"
    private static let snoKey = "sno"
    private static let nameKey = "name"
    
    
    var btnItem: UIBarButtonItem!
    
    var bySearch:Bool = false
    var snoSearch: String!
    var nameSearch:String!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let resultsController = StuInfoSearchResultsTableViewController()
        searchController = UISearchController(searchResultsController: resultsController)
        searchBar = searchController.searchBar
        searchBar.placeholder = "eg: 张三"
        tableView.tableHeaderView = searchBar
        
        btnItem = UIBarButtonItem.init(title: "添加", style: .done, target: self, action: #selector(addBtnPressed))
        navigationItem.rightBarButtonItem = btnItem
        
        //在父视图里定义子视图的委托
        resultsController.delegate = self as SearchCellSelectDelegate
        
        searchController.searchResultsUpdater = resultsController
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func addBtnPressed(){
        self.performSegue(withIdentifier: "AddStuInfo", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: StuInfoTableViewController.stuInfoEntity)
        
        students.removeAll()
        snos.removeAll()
        stuNames.removeAll()
        
        bySearch = false
        
        
        do {
            let objects = try context.fetch(request)
            for object in objects{
                
                let name = (object as AnyObject).value(forKey: StuInfoTableViewController.nameKey)as? String ?? ""
                stuNames.append(name)
                
                let sno = (object as AnyObject).value(forKey: StuInfoTableViewController.snoKey)as? String ?? ""
                snos.append(sno)
                students[sno] = name
                
            }
            
            
        } catch {
            print("error: " + "\(error)")
        }
        
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stuNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stuInfoTableIdentifier, for: indexPath)

        // Configure the cell...

        cell.detailTextLabel?.text = snos[indexPath.row]
        cell.textLabel?.text = students[snos[indexPath.row]]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddStuInfo"){
            let infoVC = segue.destination as! EditStuInfoViewController
            infoVC.navigationItem.title = "Add stuInfo"
            infoVC.isAdd = true
            
        } else {
            if (bySearch){
                let infoVC = segue.destination as! StuInfoDetailTableViewController
                infoVC.navigationItem.title = "StuInfodetails"
                infoVC.stuNo = snoSearch
                infoVC.stuName = nameSearch
            } else {
                let infoVC = segue.destination as! StuInfoDetailTableViewController
                infoVC.navigationItem.title = "StuInfodetails"
                let tableViewCell = sender as! UITableViewCell
                let indexPath = tableView.indexPath(for: tableViewCell)!
                let sno = snos[indexPath.row]
                let name = students[sno]
                infoVC.stuNo = sno
                infoVC.stuName = name
            }
        }
    }

    func cellSelect(couponID: Int!,cellItem: UITableViewCell, snoValue:String!,  nameValue:String!) {
        if ( couponID==1 ){
            
            searchBar.inputAccessoryView?.isHidden = true
            
            searchBar.inputAccessoryView?.removeFromSuperview()
            searchController.view.removeFromSuperview()
            searchController.removeFromParentViewController()
            stuInfoSearchResultsTableViewController.view.removeFromSuperview()
            searchBar.removeFromSuperview()
            
            bySearch = true
            snoSearch = snoValue
            nameSearch = nameValue
            
            
            self.performSegue(withIdentifier: "StuInfoDetailTableViewCell", sender: cellItem)
            
            
        }
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
