//
//  ViewController.swift
//  Capitol Words
//
//  Created by srihari padmanabhan on 10/31/14.
//  Copyright (c) 2014 docusign. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    @IBOutlet var wordsTable: UITableView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        self.pageNum = 0
        self.data = []
    }
    
    var data: [AnyObject]!
    var year : String!
    var month : String!
    var pageNum : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchDataForNextPage()

        // Do any additional setup after loading the view, typically from a nib.
    }

    func fetchDataForNextPage() {
        if(NetworkReachability.isNetworkReachable()) {
            let api = "http://capitolwords.org/api/1/phrases.json?entity_type=month&entity_value=\(self.year)\(self.month)&sort=count%20desc&apikey=1a6674315e404f6f8ddcfa76aab4bad7&page=\(self.pageNum)"
        
            let url = NSURL(string:api)
            var session = NSURLSession.sharedSession()
        
            var task:NSURLSessionDataTask = session.dataTaskWithURL(url!, completionHandler:apiCompletionHandler)
        
            task.resume()
            println("api call started")
        
            self.pageNum = self.pageNum + 1
        } else {
            NetworkReachability.showNetworkUnreachableAlert()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.data != nil) {
            return self.data.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailView = self.storyboard?.instantiateViewControllerWithIdentifier("detail_view") as DetailViewController
        detailView.word = self.data[indexPath.row]["ngram"] as? String
        self.navigationController?.pushViewController(detailView, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("wordtable_cell", forIndexPath: indexPath) as UITableViewCell
        
        var word = self.data[indexPath.row]["ngram"] as? String
        var count = self.data[indexPath.row]["count"] as? Int
        var countText = "( Count: \(count!) )"
        cell.textLabel.text = "\(indexPath.row). \(word!)\t\t\(countText)"
        
        return cell
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        // UITableView only moves in one direction, y axis
        var currentOffset :CGFloat = scrollView.contentOffset.y
        var maximumOffset :CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if (maximumOffset - currentOffset <= 10.0) {
            self.fetchDataForNextPage()
        }
    }
    
    func apiCompletionHandler(data:NSData!, response:NSURLResponse!, error:NSError!) {
        if (error != nil) {
            println("API error: \(error), \(error.userInfo)")
        }
        
        var jsonError:NSError?
        
        if (jsonError != nil) {
            println("Error parsing json: \(jsonError)")
        }
        else {
            println("api call completed")
            
            let json:NSMutableArray! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as NSMutableArray!
            
            for item in json {
                self.data.append(item)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.wordsTable.reloadData()
            })
        }
    }
}

