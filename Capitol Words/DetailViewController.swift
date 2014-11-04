//
//  DetailViewController.swift
//  Capitol Words
//
//  Created by srihari padmanabhan on 11/2/14.
//  Copyright (c) 2014 docusign. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var wordLengthLabel: UILabel!
    
    var wordLengthLabelText : String!
    var word : String!
    
    override func viewDidAppear(animated: Bool) {
        self.wordLengthLabel.text = self.wordLengthLabelText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = "http://api.dialectte.com:8181/api/prod/charactercount?word=\(self.word)"
        
        let url = NSURL(string:api)
        var session = NSURLSession.sharedSession()
        
        var task:NSURLSessionDataTask = session.dataTaskWithURL(url!, completionHandler:lengthApiCompletionHandler)
        
        task.resume()
        
        self.navigationItem.title = self.word

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lengthApiCompletionHandler(data:NSData!, response:NSURLResponse!, error:NSError!) {
        if (error != nil) {
            println("API error: \(error), \(error.userInfo)")
        }
        
        var jsonError:NSError?
        
        let json:NSArray = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSArray
        
        if (jsonError != nil) {
            println("Error parsing json: \(jsonError)")
        }
        else {
            var length = json[0]["length"] as Int
            
            dispatch_async(dispatch_get_main_queue(), {
                self.wordLengthLabelText = "\(length)"
            })
        }
    }
}
