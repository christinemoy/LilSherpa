//
//  ActivityDetailViewController.swift
//  
//
//  Created by Christine Moy on 4/26/15.
//
//
import Parse
import UIKit

class ActivityDetailViewController: UIViewController {
    
    var activity = String()

    @IBOutlet weak var activityNameLabel: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        activityNameLabel.text = activity
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
