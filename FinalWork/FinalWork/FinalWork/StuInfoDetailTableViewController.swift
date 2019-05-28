//
//  StuInfoDetailTableViewController.swift
//  FinalWork
//
//  Created by alu on 2019/5/24.
//  Copyright © 2019年 alu. All rights reserved.
//

import UIKit
import CoreData

class  StuInfoDetailTableViewController: UITableViewController, CouponTableViewCellDelegate, EditStuInfoBySnoDelegate {
    
    let stuInfoDetailsCellIndentifier = "StuInfoDetailTableViewCell"
    let stuInfoDetailIndentifier = "StuInfoDetails"
    let stuEntityName = "StuInfo"
    let snoKey =  "sno"
    let nameKey = "name"
    let deptKey = "dept"
    let addrKey = "addr"
    let idcardKey = "idcard"
    let phoneKey = "phone"
    let emailKey = "email"
    
    var stuInfoDetail:[String: String]! = [:]
    var keys: [String]!
    
    var stuName: String!
    var stuNo: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        keys = ["name", "sno", "dept", "idcard", "addr", "phone", "email"]
        
        
        tableView.register(StuInfoDetailTableViewCell.self, forCellReuseIdentifier: self.stuInfoDetailsCellIndentifier)
        let xib = UINib(nibName: "StuInfoDetailTableViewCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: self.stuInfoDetailsCellIndentifier)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stuInfoDetail.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: self.stuEntityName)
        
        //name is not null
        if stuName != nil{
            let pred = NSPredicate(format: "sno = " + stuNo)
            request.predicate = pred
            
        }
        stuInfoDetail[keys[0]] = stuName
        do{
            let objects = try context.fetch(request)
            for object in objects{
                let sno = (object as AnyObject).value(forKey: self.snoKey) as? String ?? ""
                stuInfoDetail[keys[1]] = sno
                let dept = (object as AnyObject).value(forKey: self.deptKey) as? String ?? ""
                stuInfoDetail[keys[2]] = dept
                let idcard = (object as AnyObject).value(forKey: self.idcardKey) as? String ?? ""
                stuInfoDetail[keys[3]] = idcard
                let addr = (object as AnyObject).value(forKey: self.addrKey) as? String ?? ""
                stuInfoDetail[keys[4]] = addr
                let phone = (object as AnyObject).value(forKey: self.phoneKey) as? String ?? ""
                stuInfoDetail[keys[5]] = phone
                let email = (object as AnyObject).value(forKey: self.emailKey) as? String ?? ""
                stuInfoDetail[keys[6]] = email
                
            }

        }catch{
            print("error:" + "\(error)")
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
        return keys.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return keys[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(section == keys.count - 1){
            return 2
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if ((indexPath.section == keys.count-1)&&(indexPath.row==1)){
            let cell = tableView.dequeueReusableCell(withIdentifier: self.stuInfoDetailsCellIndentifier, for: indexPath) as! StuInfoDetailTableViewCell
            cell.delegate = self
            return cell
            
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: self.stuInfoDetailIndentifier, for: indexPath)
        let key = keys[indexPath.section]
        cell.textLabel?.text = stuInfoDetail[key]
        // Configure the cell...

        return cell
    }
    
    
    func couponBtnClick(couponID:Int!) {
        if (couponID == 1) {
            self.performSegue(withIdentifier: "UpdateStuInfo", sender: self)
        }
        if (couponID == 2){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: self.stuEntityName)
            if (stuName == nil) {
                print("stuName is nil")
            }
            let pred = NSPredicate(format: "sno = "+"'" + stuNo + "'")
            request.predicate = pred
            
            print(stuName)
            
            //delete
            do {
                let objects = try context.fetch(request)
                for object in objects {
                    context.delete(object as! NSManagedObject)
                }
                
            } catch {
                print("error: " + "\(error)")
            }
            
            appDelegate.saveContext()
            
            
            
            //返回到上一个视图
            let infoVC = self.navigationController?.popViewController(animated: true)
            infoVC?.viewDidLoad()
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let editVC = segue.destination as! EditStuInfoViewController
        editVC.title = "编辑学生信息"
        editVC.stuName = stuInfoDetail["name"]
        editVC.stuSno = stuInfoDetail["sno"]
        editVC.delegate = self
        print(editVC.stuName)

    }
 
    func changeSno(newSno: String!) {
        stuNo = newSno
    }
}
