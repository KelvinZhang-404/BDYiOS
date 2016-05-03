//
//  TripViewController.swift
//  BDY
//
//  Created by 张联学 on 18/12/2015.
//  Copyright © 2015 gdt. All rights reserved.
//

import UIKit

class TripViewController: UIViewController {

    // Mark: Properties
    var trip: Trip?
    
    @IBOutlet weak var tripImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let trip = trip {
            navigationItem.title = trip.name
            tripImageView.image = trip.image
        }
        checkImageSize()
    }

    func checkImageSize() {
        if trip!.image?.size.height != nil {
            print((trip!.image?.size.width)! / trip!.image!.size.height)
        } else {
            print("No image selected")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
