//
//  LoginViewController.swift
//  FinalWork
//
//  Created by alu on 2019/5/25.
//  Copyright © 2019年 alu. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    private static let userEntityName = "User"
    private static let accountKey = "account"
    private static let passwordKey = "password"
    
    var users: [String:String] = [:]
    var account: String!
    var password: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: LoginViewController.userEntityName)
        
        /// 添加登陆用户
        //addUser()
        
        do {
            let objects = try context.fetch(request)
            for object in objects{
                let account = (object as AnyObject).value(forKey: LoginViewController.accountKey) as? String ?? ""
                let password = (object as AnyObject).value(forKey: LoginViewController.passwordKey) as? String ?? ""
                users[account] = password
                
            }
        } catch {
            print("error: " + "\(error)")
        }
        
    }
    
    @IBAction func LoginBtn(_ sender: Any) {
        
        if (users[accountTextField.text!] == passwordTextField.text!){
            self.performSegue(withIdentifier: "login", sender: self)
        } else {
            let alertController = UIAlertController(title: "error: account/password", message: nil, preferredStyle: .alert)
            //显示提示框
            self.present(alertController, animated: true, completion: nil)
            //两秒钟后自动消失
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
        }
        
    }
    
    
    func addUser(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        
        do {
            var data: NSManagedObject!
            data = NSEntityDescription.insertNewObject(forEntityName: LoginViewController.userEntityName, into: context) as NSManagedObject
            data.setValue("user", forKey: LoginViewController.accountKey)
            data.setValue("123456", forKey: LoginViewController.passwordKey)
            
        } catch {
            print("error: " + "\(error)")
        }
        
        appDelegate.saveContext()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

