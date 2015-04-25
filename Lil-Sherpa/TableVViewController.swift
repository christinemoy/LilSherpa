import Parse
import UIKit

class TableVViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource {
    var students = [PFObject]()
    var refreshControl : UIRefreshControl?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadStudents()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "loadStudents", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(refreshControl!)
        
    }
    
    @IBAction func addStudent(sender: AnyObject) {
//        var alert = UIAlertController(title: "Add Student", message: "Enter name below", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        alert.addTextFieldWithConfigurationHandler { (textfield) -> Void in
//            textfield.placeholder = "Student name"
//        }
//        
//        var saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action) -> Void in
//            let name = (alert.textFields![0] as! UITextField).text
//            
//            var student = PFObject(className:"People")
//            student["name"] = name
//            student.saveInBackgroundWithBlock {
//                (success: Bool, error: NSError?) -> Void in
//                if (success) {
//                    // The object has been saved.
//                } else {
//                    // There was a problem, check error.description
//                }
//            }
//            self.loadStudents()
//        }
//        
//        alert.addAction(saveAction)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//        
//        
//        presentViewController(alert, animated: true, completion: nil)
    }
    
    func loadStudents(name: String? = nil, sortAsc: Bool? = nil) {
        var query = PFQuery(className:"Activity_Provider")
        if let name = name {
            query.whereKey("name", equalTo:name)
        }
        
        if let sortAsc = sortAsc {
            if sortAsc {
                query.orderByAscending("name")
            } else {
                query.orderByDescending("name")
            }
        }
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as? [PFObject] {
                    self.students = objects
                }
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            } else {
                // Log details of the failure
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        loadStudents(name: searchBar.text)
    }
    
    func sortStudents(asc: Bool){
        loadStudents(sortAsc: asc)
    }
    
    @IBAction func sortOptions(sender: AnyObject) {
//        var sortOptions = UIAlertController(title: "Sort", message: "Select sort options", preferredStyle: UIAlertControllerStyle.ActionSheet)
//        
//        let asc = UIAlertAction(title: "Ascending", style: UIAlertActionStyle.Default) { (action) -> Void in
//            self.sortStudents(true)
//        }
//        
//        let desc = UIAlertAction(title: "Descending", style: UIAlertActionStyle.Default) { (action) -> Void in
//            self.sortStudents(false)
//        }
//        
//        sortOptions.addAction(asc)
//        sortOptions.addAction(desc)
//        sortOptions.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//        
//        presentViewController(sortOptions, animated: true, completion: nil)
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        loadStudents()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("nameCell") as! UITableViewCell
        
        let student = students[indexPath.row]
        cell.textLabel!.text = student["name"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let student = students[indexPath.row]
            student.deleteInBackgroundWithBlock{ (_, error) -> Void in
                if let error = error {
                    println("you dont have rights delete it - \(error.description)")
                } else {
                    self.students.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    println("deleted successfully")
                }
                
            }
            
        }
    }
    
}