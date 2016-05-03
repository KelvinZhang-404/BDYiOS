//
//  EditProductViewController.swift
//  BDY
//
//  Created by 张联学 on 26/02/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import UIKit

class EditProductViewController: UIViewController {
    
    var tripProductListLoader = TripProductListLoader()
    var productList: [TripProduct]?
    var tripProduct: TripProduct!
    var indexPath: NSIndexPath!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var departureTimeField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var productNumberField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(self.indexPath.row)
        
        productList = tripProductListLoader.getList()
        tripProduct = productList![indexPath.row]
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        productName.text = tripProduct.name
        departureTimeField.text = tripProduct.departureTime
        productNumberField.text = String(tripProduct.unitNumber)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // Mark: @IBAction
    @IBAction func dateSelecter(sender: UITextField) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func cancelBarButtonItemClicked(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveBarButtonItemClicked(sender: UIBarButtonItem) {
        TripProductListLoader.tripProductList[indexPath.row].departureTime = departureTimeField.text!
        print(TripProductListLoader.tripProductList[indexPath.row].departureTime)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            TripProductListLoader.tripProductList[indexPath.row].departureTime = departureTimeField.text!
            TripProductListLoader.tripProductList[indexPath.row].unitNumber = Int(productNumberField.text!)!
            print(TripProductListLoader.tripProductList[indexPath.row].departureTime)
        }
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .ShortStyle
        departureTimeField.text = timeFormatter.stringFromDate(sender.date)
    }
}
