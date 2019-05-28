//
//  EditStuInfoViewController.swift
//  FinalWork
//
//  Created by alu on 2019/5/24.
//  Copyright © 2019年 alu. All rights reserved.
//

import UIKit
import CoreData

class EditStuInfoViewController: UIViewController {

    @IBOutlet weak var sno: UITextField!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addr: UITextField!
    @IBOutlet weak var idcard: UITextField!
    @IBOutlet weak var dept: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    
    private static var stuEntityName = "StuInfo"
    private static var snoKey = "sno"
    private static var nameKey = "name"
    private static var deptKey = "dept"
    private static var addrKey = "addr"
    private static var idcardKey = "idcard"
    private static var phoneKey = "phone"
    private static var emailKey = "email"

    
    
    var isAdd: Bool = false
    
    var keys: [String]!
    
    var stuName: String!
    var stuSno: String!
    
    var delegate: EditStuInfoBySnoDelegate!
    var btnItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        keys = [EditStuInfoViewController.nameKey, EditStuInfoViewController.snoKey, EditStuInfoViewController.deptKey, EditStuInfoViewController.idcardKey, EditStuInfoViewController.addrKey, EditStuInfoViewController.phoneKey, EditStuInfoViewController.emailKey]
        
        btnItem = UIBarButtonItem.init(title: "save", style: .done, target: self, action: #selector(saveBtnPressed))
        navigationItem.rightBarButtonItem = btnItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        name.text = stuName
        if(!isAdd){
            name.isHidden = true
            nameLabel.text = stuName
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: EditStuInfoViewController.stuEntityName)

        if(!isAdd){
            let pred = NSPredicate(format: "sno = '" + stuSno + "'")
            request.predicate = pred
            do{
                let objects = try context.fetch(request)
                for object in objects{
                    
                    name.text = stuName
                    let sNo = (object as AnyObject).value(forKey: EditStuInfoViewController.snoKey) as? String ?? ""
                    sno.text = sNo
                    let deptValue = (object as AnyObject).value(forKey: EditStuInfoViewController.deptKey) as? String ?? ""
                    dept.text = deptValue
                    let idnum = (object as AnyObject).value(forKey: EditStuInfoViewController.idcardKey) as? String ?? ""
                    idcard.text = idnum
                    let addrtmp = (object as AnyObject).value(forKey: EditStuInfoViewController.addrKey) as? String ?? ""
                    addr.text = addrtmp
                    let phonenum = (object as AnyObject).value(forKey: EditStuInfoViewController.phoneKey) as? String ?? ""
                    phone.text = phonenum
                    let email1 = (object as AnyObject).value(forKey: EditStuInfoViewController.emailKey) as? String ?? ""
                    email.text = email1
            }
            }catch{
                print("error: " + "\(error)")
            }
        }
    }

    func saveBtnPressed(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: EditStuInfoViewController.stuEntityName)
        if (isAdd) {
            stuSno = sno.text
        }
        let pred = NSPredicate(format: "sno = '" + stuSno + "'")
        request.predicate = pred
        
        if (stuSno != sno.text){
            do {
                let objects = try context.fetch(request)
                let theLine: NSManagedObject! = objects.first as? NSManagedObject
                context.delete(theLine)
                appDelegate.saveContext()
            } catch {
                delete("error")
            }
        }
        let oldSno = stuSno
        stuSno = sno.text
        do {
            let objects = try context.fetch(request)
            var theLine: NSManagedObject! = objects.first as? NSManagedObject
            if ((theLine != nil) && (oldSno != stuSno)) {
                print("sno should be unique")
                return
            }
            if (theLine == nil) {
                theLine = NSEntityDescription.insertNewObject(forEntityName: EditStuInfoViewController.stuEntityName, into: context) as NSManagedObject
            }
            theLine.setValue(name.text, forKey: EditStuInfoViewController.nameKey)
            theLine.setValue(sno.text, forKey: EditStuInfoViewController.snoKey)
            theLine.setValue(dept.text, forKey: EditStuInfoViewController.deptKey)
            theLine.setValue(addr.text, forKey: EditStuInfoViewController.addrKey)
            theLine.setValue(idcard.text, forKey: EditStuInfoViewController.idcardKey)
            theLine.setValue(phone.text, forKey: EditStuInfoViewController.phoneKey)
            theLine.setValue(email.text, forKey: EditStuInfoViewController.emailKey)
            
        } catch {
            print("error: " + "\(error)")
        }
        appDelegate.saveContext()
        if (isAdd){
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
            delegate.changeSno(newSno: stuSno)
        }
    }
    
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol EditStuInfoBySnoDelegate {
    func changeSno(newSno:String!)
}
