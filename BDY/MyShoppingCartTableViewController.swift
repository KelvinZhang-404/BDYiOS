//
//  MyShoppingCartTableViewController.swift
//  BDY
//
//  Created by 张联学 on 20/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import UIKit

class MyShoppingCartTableViewController: UITableViewController {
    
    var api: API?
    var tripProductListLoader = TripProductListLoader()
    var productList: [TripProduct]?
//    var editButton: UIBarButtonItem?
//    @IBOutlet weak var editPopupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("My Shopping Cart Table View Displayed")
        self.api = API()
        api?.getCsrfToken()
        
//        editPopupView.hidden = true
        productList = tripProductListLoader.getList()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.rightBarButtonItem?.title = "修改订单"
        if productList?.count == 0 {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    func editProduct() {
//        tableView.userInteractionEnabled = true
        print("edit button clicked")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if productList!.isEmpty {
            return 1
        } else {
            return productList!.count
        }
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("shoppingCartItemCell") as! ShoppingCartItemTableViewCell
        headerCell.productName.text = "商品名称"
        headerCell.unitPrice.text = "单价"
        headerCell.departTime.text = "出发时间"
        headerCell.unitNumber.text = "数量"
        headerCell.totalPrice.text = "总价"
        headerCell.contentView.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        
//        headerCell.textLabel?.font = UIFont.boldSystemFontOfSize(18)
        headerCell.productName.font = UIFont.boldSystemFontOfSize(18)
        headerCell.unitPrice.font = UIFont.boldSystemFontOfSize(18)
        headerCell.departTime.font = UIFont.boldSystemFontOfSize(18)
        headerCell.unitNumber.font = UIFont.boldSystemFontOfSize(18)
        headerCell.totalPrice.font = UIFont.boldSystemFontOfSize(18)
        
        headerCell.productName.textAlignment = NSTextAlignment.Center
        headerCell.contentView.alpha = 1
        // Return tableViewCell.contentView will make header position fixed when delete a row
        return headerCell.contentView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        self.tableView.estimatedSectionHeaderHeight = 44
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if productList!.isEmpty {
//            print("empty product list")
            let cell = tableView.dequeueReusableCellWithIdentifier("emptyShoppingCartCell", forIndexPath: indexPath)
            cell.userInteractionEnabled = false
            return cell
        } else {
//            print("product list is not empty")
            let cell = tableView.dequeueReusableCellWithIdentifier("shoppingCartItemCell", forIndexPath: indexPath) as! ShoppingCartItemTableViewCell
            let product = productList![indexPath.row]
            cell.productName.text = product.name
            cell.productName.textAlignment = NSTextAlignment.Center
            cell.unitPrice.text = "$\(product.unitPrice)"
            cell.departTime.text = product.departureTime
            cell.unitNumber.text = String(product.unitNumber)
            cell.totalPrice.text = "$\(product.unitPrice * Double(product.unitNumber))"
//            cell.userInteractionEnabled = false
            return cell
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if !productList!.isEmpty {
            if editingStyle == .Delete {
                // Delete the row from the data source
                productList!.removeAtIndex(indexPath.row)
                tripProductListLoader.setList(productList!)
                tableView.reloadData()
//                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//                tableView.reloadData()
            } else if editingStyle == .Insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
        if self.productList?.count == 0 {
            self.navigationItem.rightBarButtonItem?.enabled = false
            self.navigationItem.rightBarButtonItem?.title = "修改订单"
        }
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if productList!.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        self.tableView.estimatedRowHeight = 88.0
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !productList!.isEmpty {
            if self.tableView.editing {
                performSegueWithIdentifier("ModifyProduct", sender: indexPath)
            } else {
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            /*
            let alertController = UIAlertController(title: "加载数据失败", message:
                "请确认您已连接到任意网络\n并退出程序重新进入", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
//            editPopupView.hidden = false
*/
        }
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ModifyProduct" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let editProductViewController = navigationController.topViewController as! EditProductViewController
            editProductViewController.indexPath = sender as! NSIndexPath
        }
    }
    
    @IBAction func checkoutButtonClicked(sender: UIButton) {
//        print(productList![0].departureTime)
        api?.httpGet(url: "shopping/cart/json/", withData: "", completion: { (data) -> Void in
            print(data["order_list"]!)
        })
//        api?.httpPost(url: "shopping/cart/add/json/", withData: <#T##String#>, completion: <#T##(data: NSDictionary) -> Void#>)
    }
    
    @IBAction func unwindFromProductEditingViewController(sender: UIStoryboardSegue) {
//        print("dafsd")
        if let _ = sender.sourceViewController as? EditProductViewController {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
        }
//        self.tableView.reloadData()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.navigationItem.rightBarButtonItem?.title = "完成修改"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "修改订单"
        }
    }
    
}
