//
//  StuInfoSearchResultsTableViewController.swift
//  FinalWork
//
//  Created by alu on 2019/5/24.
//  Copyright © 2019年 alu. All rights reserved.
//

import UIKit
import CoreData

class StuInfoSearchResultsTableViewController: UITableViewController, UISearchResultsUpdating {
    let stuInfoTableIdentifier = "StuInfoDetails"
    var students: [String:String] = [:]
    private static let studentCell = "StuInfoDetails"
    
    var filtersno: [String]! = []
    private static let stuInfoEntityName = "StuInfo"
    private static let snoKey = "sno"
    private static let nameKey = "name"
    var delegate: SearchCellSelectDelegate!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: stuInfoTableIdentifier)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: StuInfoSearchResultsTableViewController.stuInfoEntityName)
        
        students.removeAll()
        
        do {
            let objects = try context.fetch(request)
            for object in objects{
                
                let name = (object as AnyObject).value(forKey: StuInfoSearchResultsTableViewController.nameKey)as? String ?? ""
                let sno = (object as AnyObject).value(forKey: StuInfoSearchResultsTableViewController.snoKey)as? String ?? ""
                students[sno] = name
                
            }
        } catch {
            print("error" + "\(error)")
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersno.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StuInfoSearchResultsTableViewController.studentCell, for: indexPath)

        cell.textLabel?.text = students[filtersno[indexPath.row]]
        cell.detailTextLabel?.text = filtersno[indexPath.row]
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text{
            filtersno.removeAll()
            for (sno,name) in students{
                let pinyin = name.transformToPinyin()
                
                if ((pinyin.range(of: searchString, options: String.CompareOptions.caseInsensitive,range:nil,locale:nil)) != nil){
                    filtersno.append(sno)
                }
            }
        }
        tableView.reloadData()
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let sno = filtersno[indexPath.row]
        let name = students[sno]
        delegate.cellSelect(couponID: 1,cellItem: cell!,snoValue: sno,nameValue: name)
    }
}


protocol SearchCellSelectDelegate {
        func cellSelect(couponID:Int!,cellItem:UITableViewCell,snoValue:String!,nameValue:String!)
    }

