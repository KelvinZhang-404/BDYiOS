//
//  ViewController.swift
//  BDY
//
//  Created by 张联学 on 16/12/2015.
//  Copyright © 2015 gdt. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    // Mark: Properties
    @IBOutlet weak var adNumber: UILabel!
    var timer: NSTimer? = nil
    var count = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("ViewDidLoad")
        // Do any additional setup after loading the view, typically from a nib.
        restoreState()
        adNumber.text = String(count)
    }

    override func viewDidAppear(animated: Bool) {
//        print("ViewDidAppear")
        restoreState()
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "controllNavigation", userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(animated: Bool) {
//        print("ViewDidDisappear")
        saveState()
    }
    
    func saveState() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        userDefault.setInteger(count, forKey: "count")
        userDefault.synchronize()
    }
    
    func restoreState() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        count = userDefault.integerForKey("count")
        count++
//        print("count: \(count)")
    }
    
    // Navigate to a specific View
    func controllNavigation() {
        self.performSegueWithIdentifier("toTabbarView", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

