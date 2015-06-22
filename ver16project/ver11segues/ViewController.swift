//  ViewController.swift
//  ver16segues
//
//  Created by Richard H Woolley on 6/15/15.
//  Copyright (c) 2015 Bright Quasar Software, R. Woolley. All rights being understood to require force to secure. 

import UIKit  // this includes Fondation 

class ViewController: UIViewController, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!

  var people = [Person]()            // people is an array of Persons, the () is initializer syntax.
  var myInfo = [String: Person]()    // dictionary syntax, tableView will now get its ... cells, from this dictionary.
  // the initializer syntax () used above, allows us to "appear" to not assign values to these intance vars.
  // including the word "info" is a good practice when naming a dictionary which is being used in this way.

  override func viewDidLoad() {  // only fires once, so, is a bad place to put stuff other than the "initializers" below
    super.viewDidLoad()
    tableView.dataSource = self  // refers to the people var of Person type, above. Magically it finds people -- via self?

    let Richard = Person(firstName: "Rick", lastName: "Woolley")  // create two instances of Person class (by reference [they share])
    let scott = Person(firstName: "Scott", lastName: "StoneHocker")  // and set the two String properties of Person class
    people.append(Richard)                                // people is a class/instance var of type Person
    people.append(scott)                                   // Person has an initializer for firstName and lastName
    myInfo["me"] = Richard
    myInfo["favoredStepSon"] = scott

    let russell = Person(firstName: "Russell", lastName: "Wilson")
    let emmory = Person(firstName: "Emmory", lastName: "Sherman")
    self.people.append(russell)
    self.people.append(emmory)
    self.myInfo["bff"] = russell      // filling-out the dictionary of Persons / people
    self.myInfo["buddy"] = emmory  // russel and emmory are the values stored in the dict. 

    // Rick has added and fixed code to allow user to add Joe's first name to the tableView, just for fun.
    // Joe Namath has forgotten his first name, he is that old. And ... he is so-very-old, that he no-longer looks good in panty hose:]
    //let quarterBack = Person(firstName: " ", lastName: "Namath")
    //let quarterBack = Person(firstName: "", lastName: "Namath")  // tried using the new optional firstName member in Person, But
                                                                // ... it messes-up my "lastValue" label position, why, who knows??
    // the following works, albeit we get an extra space in front of "Namath" in the tableView cell. 
    let quarterBack = Person(firstName: " ", lastName: "Namath")
    // the above will allow QB1 to "appear" to not have a first name, sans making firstName optional in Person class.
    people.append(quarterBack)
    //QB1?.firstName  // this is from demo code, not sure what is accomplished here???????????????????????????????

    myInfo ["Rick"] = Richard                   // two synonyms in the dictionary for existing people (aka) -- NOT
    myInfo ["Mr Nishiko"] = scott              // ACTUALLY, Brad says that these keys will over-write the prior keys
  }   // so, apparently, EVERY class has an append method, and if one feeds it a related instance ... each morsel gets appended.

 // The following func reloads the table view with the data entered in DetailViewController
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()    // parens needed because reloadData is ... what? A func not in the class tableView?
    // this ^^^^^ somehow receives the data entered in DetailViewController ???????????

/*
  // the code below runs but does not receive the data entered in DetailViewController ????????????????????????????????????
    // I want to do this in a more ... efficient way ... And, how it works is explaied below. BUT  ^^^

    let indexPathToReload = NSIndexPath(forItem: 0, inSection: 0)  // option-clicking on NSIndexPath informs us that: ...
    // ... The NSIndexPath class represents the path to a specific node in a tree of nested array collections. This path is known as an index path. Each index in an index path represents the index into an array of children from one node in the tree to another, deeper, node.

    let indexPaths = [indexPathToReload]  // so [indexPathToReload] is one of those, aforementioned, bits of indexPath magic.
    tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
*/
  }


// As per the requirements of protocol UITableViewDataSource: we "overloaded" the next two funcs ... to prepare resources.
  // We use "overloading" (twice) of tableView, to allow UITableView to obtain the count of people, and to de-que a cell.
  // And also, set cell.textLabel?.text to a String (personToDisplay) containing the first_last name on selected row.
  // Though WE don't supply the two args this func reauires, it, being here to satisfy protocol, the caller surely will.
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return people.count
  }

  // de-que the cell (all old shit) discussed above         vvvv--- first is external name, indexPath is internal name
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
    let personToDisplay = people[indexPath.row]

         //cell.textLabel?.text = nil  // Rick was just testing by uncommenting this line, being super safe:]

    if let personsFistname = personToDisplay.firstName { // we could, as done here, leave personsFistname unused. Or, 
       //do it this way: cell.textLabel?.text = personsFistname + " " + personToDisplay.lastName // tested.
    cell.textLabel?.text = personToDisplay.firstName! + " " + personToDisplay.lastName   // optional chaining still allows ...
    // ... runtime error in the case where "the entire line is ignored ... "gracefully".
    // "If anything in the entire line is nil the entire line is ignored ... gracefully BUT not as gracefully as the following.
    }
     return cell
  }

  // purpose of prepareForSegue (of overriding it) is to obtain from indexPathForSelectedRow() the selectedPerson
  // ... (by using indexPath to first get the .row, and then use selectedRow to set selectedPerson property of detailViewController
  // ... you remember him, the guy obligated to follow a certain protocol, such that he can be a qualifies delegate.
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "ShowDetailViewController" {
      if let detailViewController = segue.destinationViewController as? DetailViewController {
        //let myIndexPath = self.tableView.indexPathForSelectedRow()
        if let indexPath = self.tableView.indexPathForSelectedRow() {
          let selectedRow = indexPath.row
          let selectedPerson = self.people[selectedRow]
          detailViewController.selectedPerson = selectedPerson  // here must be where we pass the data to detailViewController.
        }  else {
          //let selectedPerson = people[0]  // I "think" this would work? -- but, it was a dumb idea ...
          //detailViewController.selectedPerson = selectedPerson
          // ... NO, if self.tableView.indexPathForSelectedRow() were ever nil we would be toasted anyway.
          // Likewise, if segue.destinationViewController as! DetailViewController were ever nil we would be toasted anyway.
        }
      }
    }
  }
/*
          else {
            //var indexPath = tableView?.indexPathForSelectedRow()
            //let indexPathToReload = NSIndexPath(forItem: 0, inSection: 0)
            //indexPath = [indexPathToReload]
            //let selectedRow = indexPath
            let selectedPerson = people[3]
            detailViewController.selectedPerson = selectedPerson
          }
*/

}

/*  Xcode gives the following advice for free, if only Siri were so ... thoughtful:]

In a storyboard-based application, you will often want to do a little preparation before navigation ...

override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
// Get the new view controller using segue.destinationViewController.
// Pass the selected object to the new view controller.
}

*/


