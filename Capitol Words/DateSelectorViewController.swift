//
//  DateSelectorViewController.swift
//  Capitol Words
//
//  Created by srihari padmanabhan on 11/2/14.
//  Copyright (c) 2014 docusign. All rights reserved.
//

import UIKit

class DateSelectorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var picker: UIPickerView!
    
    var months : NSMutableArray!
    var years : NSMutableArray!
    var selectedYear : String!
    var selectedMonth : String!
    
    @IBAction func goButtonPressed(sender: AnyObject) {
        let wordsView = self.storyboard?.instantiateViewControllerWithIdentifier("wordsView") as ViewController
        wordsView.year = self.selectedYear
        wordsView.month = self.selectedMonth
        wordsView.pageNum = 0
        
        self.navigationController?.pushViewController(wordsView, animated: true)
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        years = NSMutableArray()
        months = NSMutableArray()
        
        for year in 1996...2014 {
            years.addObject(year)
        }
        
        for month in 1...12 {
            months.addObject(month)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component == 0) {
            return self.years.count
        } else {
            return self.months.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0) {
            self.selectedYear = "\(self.years[row])"
        } else {
            var month : Int = self.months[row] as Int
            var formattedMonth = NSString(format:"%02d", month)
            self.selectedMonth = "\(formattedMonth)"
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
            if(component == 0) {
                return "\(self.years[row])"
            } else {
                var month : Int = self.months[row] as Int
                var formattedMonth = NSString(format:"%02d", month)
                return "\(formattedMonth)"
            }
    }
}
