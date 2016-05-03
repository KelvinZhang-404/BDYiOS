//
//  API.swift
//  BDY
//
//  Created by 张联学 on 6/01/2016.
//  Copyright © 2016 gdt. All rights reserved.
//

import Foundation

protocol ApiDelegate: class {
    func errorHandler(error: NSError?)
}

class API {
    let BASE_URL: String = "http://www.bendiyou.com.au/"
    var csrfToken: String?
    
    weak var delegate: ApiDelegate?
    
    func getCsrfToken() {
        let characterSet: NSMutableCharacterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString(":/-._~=?")
        let url: String = (BASE_URL + "get_csrf_token/").stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response, data, error) -> Void in
            if error != nil {
            } else {
                var jsonData: NSDictionary
                do {
                    if let returnedData = data {
                        jsonData = try NSJSONSerialization.JSONObjectWithData(returnedData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        self.csrfToken = jsonData.valueForKey("token") as? String
                    }
                    
                } catch {
                    
                }
                
            }
            
        })
    }
    
    func httpGet(var url url: String, withData data: String, completion: (data: NSDictionary) -> Void) {
        let characterSet: NSMutableCharacterSet = NSMutableCharacterSet.alphanumericCharacterSet()
        characterSet.addCharactersInString(":/-._~=?")
        if data != "" {
            url += "?"
            url += data
        }
        
        let url: String = (BASE_URL + url).stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response, data, error) -> Void in
//            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            if error != nil {
                self.delegate?.errorHandler(error!)
            } else {
                var jsonData: NSDictionary
                do {
                    if let returnedData = data {
                        jsonData = try NSJSONSerialization.JSONObjectWithData(returnedData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                        completion(data: jsonData)
                    }
                } catch {
                    
                }
            }
        })
    }
    
    func httpPost(url url: String, var withData data: String, completion: (data: NSDictionary) -> Void) {
        getCsrfToken()
        if let token = self.csrfToken {
            let characterSet = NSMutableCharacterSet.alphanumericCharacterSet()
            characterSet.addCharactersInString(":/-._~=?")
            let url: String = (BASE_URL + url).stringByAddingPercentEncodingWithAllowedCharacters(characterSet)!
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            data += "&csrfmiddlewaretoken=\(token)"
            request.HTTPBody = data.dataUsingEncoding(NSUTF8StringEncoding)
            request.addValue(self.csrfToken!, forHTTPHeaderField: "X-CSRFToken")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                (response, data, error) -> Void in
                if error != nil {
                    self.delegate?.errorHandler(error!)
                } else {
                    if (response as! NSHTTPURLResponse).statusCode == 403 {
                        print("403 forbidden")
                    }
                    var jsonData: NSDictionary
                    do {
                        if let returnedData = data {
                            jsonData = try NSJSONSerialization.JSONObjectWithData(returnedData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                            completion(data: jsonData)
                            
                        }
                        
                    } catch {
                        
                    }
                }
                
            })
        } else {
            // No CSRF Token stored
            self.delegate?.errorHandler(nil)
        }

    }
}