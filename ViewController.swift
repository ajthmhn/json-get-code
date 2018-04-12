//
//  ViewController.swift
//  json.swift
//
//  Created by islet on 17/04/17.
//  Copyright © 2017 islet. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableLoan: UITableView!
var loanDetailArr = [Loan]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let task = URLSession.shared.dataTask(with: NSURL(string: "http://api.kivaws.org/v1/loans/search.json?status=fundraising")! as URL, completionHandler: { (data, response, error) -> Void in
            print("got data")
                       do{
                        
                        
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
                self.performSelector(onMainThread: #selector(self.loadTableWithJson), with: json, waitUntilDone: false)
               
            }
            catch {
                print("json error: \(error)")
            }
        })
        
        
        task.resume()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loadTableWithJson(jsonDict:[String:AnyObject]) {
        let loanArr = jsonDict["loans"] as! [[String:AnyObject]]
        for loanDict in loanArr {
            let loanObj = Loan()
            loanObj.loanId = loanDict["id"]?.integerValue
            loanObj.name = loanDict["name"] as? String
            loanObj.activity = loanDict["activity"] as? String
            loanObj.sector = loanDict["sector"] as? String
            loanObj.use = loanDict["use"] as? String
            loanObj.loanAmount = loanDict["loan_amount"]?.integerValue
            loanDetailArr.append(loanObj)
        }
print(loanDetailArr.count)
        tableLoan.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loanDetailArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "tableCellId") as! tableCell
        
        
        
        let loanObj = loanDetailArr[indexPath.row]
        Cell.tblId.text = "Id: \(loanObj.loanId!)"
        Cell.tblName.text = "Name: \(loanObj.name!)"
        Cell.tblAmount.text = "Amount: \(loanObj.loanAmount!)"
        return Cell
    }


}

