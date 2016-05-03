//
//  FirstTabViewController.swift
//  BDY
//
//  Created by 张联学 on 18/12/2015.
//  Copyright © 2015 gdt. All rights reserved.
//

import UIKit
//import BTNavigationDropdownMenu
import ReachabilitySwift

class FirstTabTableViewController: UITableViewController {

    // Mark: Properties
    var activityIndicatorView: ActivityIndicatorView?
    var api: API?
    lazy var cachedTripList = [Trip]()
    var tripList = [Trip]()
    var locations = [String]()
    var tripArray: NSArray!
    var imageURLs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.api = API()
        setup()
        self.clearsSelectionOnViewWillAppear = true
    }
    
    private func convertHTMLStringtoNSAttributedString(string: String) -> NSAttributedString {
        let modifiedFont = NSString(format:"<span style=\"font-family: PingFangSC-Regular; font-size: 16.0\">%@</span>", string) as String
        return try! NSAttributedString(
            data: modifiedFont.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding],
            documentAttributes: nil)
    }

    func setup() {
        if MyReachability.isConnectedToNetwork() {
            
            activityIndicatorView = ActivityIndicatorView(title: "Loading trips", center: self.view.center)
            self.view.addSubview(activityIndicatorView!.getViewActivityIndicator())
            self.activityIndicatorView?.startAnimating()
            
            api?.httpGet(url: "trip/list/json/", withData: "", completion: {(data: NSDictionary) in
                self.tripArray = data["trip_list"] as! NSArray
                
                
                /*------------------------------------------*/
                for trip in self.tripArray! {
//                    ImageLoader.sharedLoader.imageForUrl("http://www.bendiyou.com.au" + (trip["images"]!![0] as! String),
//                        completionHandler: {(image: UIImage?, url: String) in
//                            self.cachedTripList.append(
//                                Trip(id: trip["id"] as! Int, image: image, name: trip["name"] as! String,
//                                    locations: trip["locations"] as! [String], coverHint: self.convertHTMLStringtoNSAttributedString(trip["cover_hint"] as! String))!
//                            )
//                            if self.cachedTripList.count == self.tripArray!.count {
//                                self.tripList = self.cachedTripList
//                                self.setupLocations()
//                                self.setupNavigationBar()
//                                self.tableView.reloadData()
//                                self.activityIndicatorView?.stopAnimating()
//                            }
//                    })
                    self.imageURLs.append(trip["image"] as! String)
                    self.cachedTripList.append(
                        Trip(id: trip["id"] as! Int, image: UIImage(named: "BlankImg"), name: trip["name"] as! String,
                            locations: trip["locations"] as! [String], coverHint: self.convertHTMLStringtoNSAttributedString(trip["cover_hint"] as! String))!
                    )
                    
                    if self.cachedTripList.count == self.tripArray.count {
                        self.tripList = self.cachedTripList
                        self.setupLocations()
                        self.setupNavigationBar()
                        self.tableView.reloadData()
                        self.activityIndicatorView?.stopAnimating()
                    }
                    
                }
                /*------------------------------------------*/
                
            })
        } else {
            let alertController = UIAlertController(title: "加载数据失败", message:
                "请确认您已连接到任意网络\n并退出程序重新进入", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // Reserved func for checking internet connection status
    func checkInternetConnection() {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        reachability.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    print("Reachable via WiFi")
                } else {
                    print("Reachable via Cellular")
                }
            }
        }
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                print("Not reachable")
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    // Reserved func for listening the internet connection status
    func notificatedWhenInternetChanged() {
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "reachabilityChanged:",
            name: ReachabilityChangedNotification,
            object: reachability)
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func reachabilityChanged(note: NSNotification) {
        let reachability = note.object as! Reachability
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Not reachable")
        }
    }
    
    func setupLocations() {
        var duplicateLocations = [String]()
        for trip in tripList {
            let locations: [String] = trip.locations
            for location in locations {
                duplicateLocations.append(location)
            }
        }
        locations.append("全部")
        locations += Array(Set(duplicateLocations))
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255.0, green:153/255.0, blue:51/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: "选择地区", items: locations)
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {
            (indexPath: Int) in
            self.reloadTableView(self.locations[indexPath])
        }
    }
    
    func reloadTableView(location: String) {
        tripList.removeAll()
        if location == locations[0] {
            tripList = cachedTripList
        } else {
            for trip in cachedTripList {
                if trip.locations.contains(location) {
                    tripList.append(trip)
                }
            }
        }
        self.tableView.reloadData()
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
        
        return tripList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TripTableViewCell", forIndexPath: indexPath) as! TripTableViewCell

        /*-----------分割线，download image (start)-------------*/
        let trip = tripList[indexPath.row]
        ImageLoader.sharedLoader.imageForUrl("http://www.bendiyou.com.au" + imageURLs[indexPath.row],
            completionHandler: {(image: UIImage?, url: String) in
                trip.image = image
                cell.tripImageView.image = image
        })
        /*-----------分割线，download image (finish)-------------*/
        
        cell.tripImageView.image = trip.image
        cell.tripLabelName.text = trip.name
        cell.tripLabelName.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        cell.tripCoverHint.attributedText = trip.coverHint
        cell.tripCoverHint.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 100
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        let tripDetailTableViewController = segue.destinationViewController as! TripDetailTableViewController
        // Pass the selected object to the new view controller.
        if let selectedTripCell = sender as? TripTableViewCell {
            let indexPath = tableView.indexPathForCell(selectedTripCell)!
            let selectedTrip = tripList[indexPath.row]
            tripDetailTableViewController.trip = selectedTrip
        }
    }
    
}
// for git testing
// another test

