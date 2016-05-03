//
//  TripProductListTableViewCell.swift
//  BDY
//
//  Created by 张联学 on 12/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import UIKit

class TripProductTableViewCell: UITableViewCell, UITextFieldDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var normalPrice: UILabel!
    @IBOutlet weak var specialPrice: UILabel!
    @IBOutlet weak var selectNumberView: UITextField!
    @IBOutlet weak var selectDateView: UITextField!
    @IBOutlet weak var productTitle: UILabel!
    
    var addProductCallback: ((product: TripProduct) -> Void)?
    var viewController: UIViewController?
    var trip: Trip?
    
//    var tripProductListLoader = TripProductListLoader()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        doneBtn.hidden = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // Mark: @IBAction
    @IBAction func dateSelecter(sender: UITextField) {
        doneBtn.hidden = false
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    @IBAction func dateSelecterFinshEditing(sender: AnyObject) {
        selectDateView.resignFirstResponder()
        doneBtn.hidden = true
    }
    
    @IBAction func numberSelecterStartEditing(sender: AnyObject) {
        doneBtn.hidden = false
    }
    
    @IBAction func numberSelecterFinishEditing(sender: AnyObject) {
        selectNumberView.resignFirstResponder()
        doneBtn.hidden = true
    }
    
    @IBAction func didInputData(sender: AnyObject) {
        selectDateView.resignFirstResponder()
        selectNumberView.resignFirstResponder()
        doneBtn.hidden = true
    }
    
    @IBAction func addProduct(sender: AnyObject) {
        
        if productIsAvailable() {
            let alertController = UIAlertController(title: "确认将下列产品加入购物车？",
                message: "\(productTitle.text!)*\(selectNumberView.text!)", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: {action in
                print("Adding items to shopping cart...")
                if let addProductCallback = self.addProductCallback {
                    let newProduct = TripProduct(name: self.productTitle.text!, departureTime: self.selectDateView.text!)
                    newProduct.unitNumber = Int(self.selectNumberView.text!)!
                    addProductCallback(product: newProduct)
                }
                let alert = UIAlertController(title: "成功", message: "已成功添加到购物车", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
                self.viewController!.presentViewController(alert, animated: true, completion: nil)
            }))
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
            self.viewController!.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "加入购物车失败", message:
                "您还没有选择任何日期或者数量\n请重新选择", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Default,handler: nil))
            self.viewController!.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.addSubview(self.addToCartBtn)
        
    }
    
    func productIsAvailable() -> Bool {
        if selectDateView.text!.isEmpty || selectNumberView.text!.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .ShortStyle
        selectDateView.text = timeFormatter.stringFromDate(sender.date)
    }
    
    
}

