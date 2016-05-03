//
//  SecondTabViewController.swift
//  BDY
//
//  Created by 张联学 on 16/12/2015.
//  Copyright © 2015 gdt. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class SecondTabViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, ApiDelegate{

    var api: API?
    
    let locationManager = CLLocationManager()
    var locValue: CLLocation?
    var isMapLoaded: Bool = false
    var mapView: GMSMapView?
    
    var resortList: [Resort] = []
    var locations: [String] = []
    var menuView: BTNavigationDropdownMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.api = API()
        setup()
//        setupLocations()
//        setupNavigationBar()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        // Get dynamic position
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let camera = GMSCameraPosition.cameraWithLatitude(1.224324, longitude: 1.212234, zoom: 15)
        self.mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView!.settings.myLocationButton = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Mark: Setup
    func setup() {
//        print("setup resorts")
        api?.httpGet(url: "resort/list/json/", withData: "", completion: {(data: NSDictionary) in
            let jsonObject = data["resort_list"] as! NSArray
            
            for resort in jsonObject {
                ImageLoader.sharedLoader.imageForUrl("http://www.bendiyou.com.au" + ((resort["images"] as! NSArray)[0] as! String),
                    completionHandler:{(image: UIImage?, url: String) in
                    self.resortList.append(
                        Resort(name: resort["name"] as! String, location: resort["city_area"] as! String, website: "",
                            image: image, latitude: Double(resort["latitude"] as! String)!,
                            longitude: Double(resort["longitude"] as! String)!, distance: "n/a")
                    )
                    // Setup locations, navigation bar, map
                    self.setupLocations()
                    self.setupNavigationBar()
                    self.loadMap()
                })
            }
            
            for resort in self.resortList {
                print(resort.name)
            }
        })
    }
    
    func setupLocations() {
        var duplicatedLocations: [String] = []
        for resort in resortList {
            duplicatedLocations.append(resort.location)
        }
        locations = Array(Set(duplicatedLocations))
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255.0, green:153/255.0, blue:51/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, title: "select location", items: locations)
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {
            (indexPath: Int) in
            
            // Rewrite to implement performSegueWithIdentifier()
            print("Did select item at index: \(self.locations[indexPath])")
            self.reloadMapWithSelectedLocation(self.locations[indexPath])
        }
    }

    func setupDistance(location: CLLocation) {
        for resort in resortList {
            let position = CLLocation(latitude: resort.latitude, longitude: resort.longitude)
            let distance = position.distanceFromLocation(location) / 1000
            resort.distance = String(format: "%.2f", distance)
        }
    }
    
    func loadMap() {
        if let loc = self.locValue, mapView = self.mapView {
            let camera = GMSCameraPosition.cameraWithTarget(loc.coordinate, zoom: 15)
            mapView.animateToCameraPosition(camera)
        }
        if let mapView = self.mapView {
            mapView.delegate = self
            mapView.myLocationEnabled = true
            self.view = mapView
            
        }
        
        for resort in resortList {
            let position = CLLocationCoordinate2DMake(resort.latitude, resort.longitude)
//            resort.distance = getDistance(position)
            let marker = GMSMarker(position: position)
            marker.userData = resort
            marker.infoWindowAnchor = CGPointMake(0.44, 0.45)
            marker.icon = resort.image
            marker.title = resort.name
            marker.icon = GMSMarker.markerImageWithColor(UIColor.blackColor())
            marker.opacity = 0.7
            marker.map = mapView
        }
    }
    
    func reloadMapWithSelectedLocation(location: String) {
        self.mapView?.clear()
        for resort in self.resortList {
            if resort.location == location {
                let position = CLLocationCoordinate2DMake(resort.latitude, resort.longitude)
//                resort.distance = getDistance(position)
                let marker = GMSMarker(position: position)
                marker.userData = resort
                marker.infoWindowAnchor = CGPointMake(0.44, 0.45)
                marker.icon = resort.image
                marker.title = resort.name
                marker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
                marker.opacity = 0.7
                marker.map = mapView
            }
        }
    }
    
    // Mark: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        setupDistance(location!)
        
        let eventDate = location?.timestamp
        let howRecent = eventDate?.timeIntervalSinceNow
        if(abs(howRecent!) < 15.0) {
            self.locValue = location
        } else {
            self.locValue = manager.location
        }
        
        if !self.isMapLoaded {
            self.isMapLoaded = true
            if let mapView = self.mapView {
                locValue = manager.location
                mapView.animateToCameraPosition(GMSCameraPosition.cameraWithTarget(locValue!.coordinate, zoom: 15))
                print("locations = \(locValue!.coordinate.latitude) \(locValue!.coordinate.longitude)")
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways {
            loadMap()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        mapView?.clear()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: GMSMapViewDelegate
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        let camera = GMSCameraPosition.cameraWithTarget(marker.position, zoom: 15)
        self.mapView!.animateToCameraPosition(camera)

        return false
    }
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView {
        let view  = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil).first! as! CustomResortInfoWindow
        
        let resort = marker.userData as! Resort
        view.resortImageView.image = resort.image
        view.resortEnTitle.text = resort.name
        view.resortCnTitle.text = resort.name
        view.resortDistance.text = "\(resort.distance)km"
        
        return view
    }
    
    func mapView(mapView: GMSMapView!, didTapInfoWindowOfMarker marker: GMSMarker!) {
        performSegueWithIdentifier("secondTabToResort", sender: self.mapView(mapView, markerInfoWindow: marker))
        
    }
    
    // Mark: ApiDelegate
    func errorHandler(error: NSError?) {
        print("cannot connect to server")
    }
}
