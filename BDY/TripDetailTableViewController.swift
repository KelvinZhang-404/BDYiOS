//
//  TripDetailTableViewController.swift
//  BDY
//
//  Created by 张联学 on 12/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import UIKit

class TripDetailTableViewController: UITableViewController {

    var activityIndicatorView: ActivityIndicatorView?
    var api: API = API()
    var trip: Trip?
    let sections = ["Trip Image","Products","Other Products","Activitys","Meta Info"]
    var tableData: [TableData] = [TableData]()
    var productListLoader = TripProductListLoader()
    var productList: [TripProduct] = [TripProduct]()
    
    struct TableData {
        var section: String = ""
        var data: [AnyObject] = [AnyObject]()
        
        init(){}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = trip?.name
        
        setupDismissEditing()
        activityIndicatorView = ActivityIndicatorView(title: "Loading...", center: self.view.center)
        dealWithTableData()
        
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func viewDidAppear(animated: Bool) {
        productList = productListLoader.getList()
    }
    
    func dealWithTableData() {
        self.activityIndicatorView?.startAnimating()
        api.httpGet(url: "trip/\(String(trip!.id))/json/", withData: "", completion: {(data: NSDictionary) in
            
            let productList = data["product_list"] as! [NSDictionary]
            var imageList = [UIImage]()
            imageList.append((self.trip?.image)!)
            
            let otherProductList = data["other_product_list"] as! [NSDictionary]
            let dailyActivityList = data["daily_activity_list"] as! [NSDictionary]
            let metaInfoList = data["meta_info_list"] as! [NSDictionary]
            let metaInfoListWithUniqueType = self.setupMetaInfoList(metaInfoList)
            
            self.tableData[0].data = imageList
            self.tableData[1].data = productList
            self.tableData[2].data = otherProductList
            self.tableData[3].data = dailyActivityList
            self.tableData[4].data = metaInfoListWithUniqueType
            
            self.activityIndicatorView?.stopAnimating()
            self.tableView.reloadData()
        })
        
        initateSections()
    }
    
    func initateSections() {
        var newSection = TableData()
        for section in sections {
            newSection.section = section
            tableData.append(newSection)
        }
    }
    
    func setupMetaInfoList(metaInfoList: [NSDictionary]) -> [[String: [String]]]{
        var infoTypes: [String] = [String]()
        for metaInfo in metaInfoList {
            infoTypes.append(metaInfo["type"] as! String)
            
        }
        infoTypes = Array(Set(infoTypes))
        print(infoTypes)
        
        var metaInfoListWithUniqueType = [[String: [String]]]()
        for infoType in infoTypes {
            var descList = [String]()
            for metaInfo in metaInfoList {
                if String(metaInfo["type"]!) == infoType {
                    descList.append(String(metaInfo["description"]!))
                }
            }
            metaInfoListWithUniqueType.append([infoType: descList])
        }
        return metaInfoListWithUniqueType
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableData[section].section
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        self.tableView.estimatedRowHeight = 88.0
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableData[section].data.isEmpty {
            return 0
        } else {
            return 20
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].data.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) as! TripInfoTableViewCell
            cell.tripImage.image = tableData[indexPath.section].data[indexPath.row] as? UIImage
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! TripProductTableViewCell
            
            let data = tableData[indexPath.section].data[indexPath.row]
//            print(data["special_price"] as! String)
//            print(Double(data["special_price"] as! String)!)
            cell.productTitle.text = data["title"] as? String
            cell.normalPrice.text = "原价 $\((data["normal_price"] as? String)!)"
            cell.specialPrice.text = "现价 $\((data["special_price"] as? String)!)"
            cell.viewController = self
            // Implement addProductCallback
            cell.addProductCallback = {(newProduct: TripProduct)->Void in
                newProduct.name = self.trip!.name + ": " + newProduct.name
                newProduct.unitPrice = Double(data["special_price"] as! String)!
                if self.productList.contains(newProduct) {
                    self.updateProduct(newProduct)
                    print("updated unit of product is \(self.productList[self.productList.indexOf(newProduct)!].unitNumber)")
                } else {
                    self.productList.append(newProduct)
                    print("unit of new product is \(newProduct.unitNumber)")
                }
                print("number of items in productList \(self.productList.count)")
            }
            
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("otherProductCell", forIndexPath: indexPath) as! TripOtherProductTableViewCell
            if let otherProduct = tableData[indexPath.section].data[indexPath.row] as? NSDictionary {
            cell.productTitle.text = otherProduct["title"] as? String
            cell.productNormalPrice.text = "原价 $\((otherProduct["normal_price"] as? String)!)起"
            cell.productSepcialPrice.text = "现价 $\((otherProduct["special_price"] as? String)!)起"
            } else {
                cell.removeFromSuperview()
            }
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("tripActivityCell", forIndexPath: indexPath) as! TripActivityTableViewCell
            if let dayNumber = (tableData[indexPath.section].data[indexPath.row]["day"] as? Int) {
                cell.dayNumber.text = "第\(dayNumber)天"
            } else {
//                cell.dayNumber.removeFromSuperview()
                cell.dayNumber.text = ""
            }
            var text = tableData[indexPath.section].data[indexPath.row]["description"] as! String
            text = cell.activityDescription.getHTMLFromString(text)
            autoIndentBulletPoint(text, label: cell.activityDescription)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("metaInfoCell", forIndexPath: indexPath) as! TripMetaInfoTableViewCell
            if let myDic = tableData[indexPath.section].data[indexPath.row] as? NSDictionary {
                let type: String = myDic.allKeys[0] as! String
                cell.metaInfoType.text = type
                var text = ""
                for desc in (myDic[type] as! [String]) {
//                    text += "\u{2022}\(desc)<br>"
                    text += "\u{2022}\(desc)<br>"

                }
                text = cell.metaInfoDesc.getHTMLFromString(text)
                autoIndentBulletPoint(text, label: cell.metaInfoDesc)
            }
            return cell
        }
    }
    
    func updateProduct(product: TripProduct) {
        productList[productList.indexOf(product)!].unitNumber += product.unitNumber
    }
    
    func autoIndentBulletPoint(text: String, label: UILabel) {
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: text)
        let paragrahStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragrahStyle.paragraphSpacing = 4
        paragrahStyle.paragraphSpacingBefore = 3
        paragrahStyle.firstLineHeadIndent = 0.0
        // First line is the one with bullet point
//        paragrahStyle.headIndent = 10
        // Set the indent for given bullet character and size font
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragrahStyle, range: NSMakeRange(0, text.characters.count))
        label.attributedText = attributedString
    }
    
    // Disable row selection
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func setupDismissEditing() {
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyBoard:")
        tapGesture.cancelsTouchesInView = true
        tableView.addGestureRecognizer(tapGesture)
    }
    
    func hideKeyBoard(sender: UITapGestureRecognizer) {
        tableView.endEditing(true)
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        productListLoader.setList(productList)
////        let shoppingCartTableViewController = segue.destinationViewController as! MyShoppingCartTableViewController
////        shoppingCartTableViewController.trip = self.trip
////        shoppingCartTableViewController.productList = self.productList
//    }
    
    override func viewWillDisappear(animated: Bool) {
        productListLoader.setList(productList)
    }
}

// Mark: Convert Html to Ordinary String
extension UILabel {
    func getHTMLFromString(text: String) -> String {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>", text) as String
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
            documentAttributes: nil)
        
//        self.attributedText = attrStr
        return attrStr.string
    }
}

