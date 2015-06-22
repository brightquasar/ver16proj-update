//  DetailViewController.swift
//  ver16segues
//
//  Created by Richard H Woolley on 6/15/15.
//  Copyright (c) 2015 Bright Quasar Software, R. Woolley. All rights being understood to require force to secure. 

import UIKit  // this includes Fondation 

  class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  // 3 delegate are in effect in this class (UIImagePickerControllerDelegate requires the UINavigationControllerDelegate)

  @IBOutlet weak var firstNameLabel: UILabel!
  @IBOutlet weak var lastNameLabel: UILabel!

  @IBOutlet weak var firstNameTextField: UITextField!   // these per protocol, are found below in viewDidLoad
  @IBOutlet weak var lastNameTextField: UITextField!

  @IBOutlet weak var cameraMissingAlert: UILabel!
  @IBOutlet weak var imageView: UIImageView!

  // magic man
  var selectedPerson: Person!    // magically locatable via

    var label = UILabel(frame: CGRectMake(0, 0, 250, 21))
    var label2 = UILabel(frame: CGRectMake(0, 0, 250, 21))
    var label3 = UILabel(frame: CGRectMake(0, 0, 250, 21))

// ------------------- end of members, funcs follow ---------------------------------------------------------------

  override func viewDidLoad() {   // fires only once when THIS view is created
    super.viewDidLoad()


    //      let url = NSURL(string: "http://prod.www.seahawks.clubs.nfl.com/assets/images/imported/SEA/articleImages/RoundUp/140515-sherman-links-600.jpg")
    //      let imageData = NSData(contentsOfURL: url!)
    //      let image = UIImage(data: imageData!)
    //      self.imageView.image = image


    self.firstNameTextField.delegate = self // .delegate = self  ...obvious references to the new outlets, while self magically finds
                                            // ... selectedPerson, a class/instance var, above.
    self.lastNameTextField.delegate = self  // .delegate = self

    self.firstNameTextField.tag = 0  // these tags will be used to differentiate, below, between the two textFields in the ...
                                     // ... textFieldDidEndEditing func
    self.lastNameTextField.tag = 1

    //self.firstNameTextField.text = self.selectedPerson.firstName  // These would overWrite placeholders
    //self.lastNameTextField.text = self.selectedPerson.lastName   //

    self.firstNameLabel.text = self.selectedPerson.firstName     // these next two insert the data from the tableView into the labels
    self.lastNameLabel.text = self.selectedPerson.lastName      // ... my trick
// just to practice using Frames (will only look correct on the iPhone6 in portrait. 
    let myUnderlieView = UIView(frame: CGRect(x:15, y: 170, width: 300, height: 25))
       myUnderlieView.backgroundColor = UIColor.yellowColor()
    self.view.addSubview(myUnderlieView)
//new for jun 17
    if selectedPerson.lastName == "Namath" {
      lastNameTextField.text = selectedPerson.lastName
      //self.cameraMissingAlert.textColor = UIColor.redColor()
      //self.cameraMissingAlert.text = "Guess his first name"

      label.center = CGPointMake(150, 494)
      label.textAlignment = NSTextAlignment.Center
      label2.center = CGPointMake(150, 520)
      label2.textAlignment = NSTextAlignment.Center
      label3.center = CGPointMake(150, 545)
      label3.textAlignment = NSTextAlignment.Center
      label.text = "Try to guess the first name of"
      label2.text = "the famous person who's last"
      label3.text = "name is shown above"
      self.view.addSubview(label)
      self.view.addSubview(label2)
      self.view.addSubview(label3)
    } else {
      // leave the lastNameTextField "blank" with its place-holder text
    }
  }
// -------------- end of viewDidLoad() ---------------------------------------------------------------------------

  // the next two funcs are per protocol UITextFieldDelegate, obviously, there will be a caller of these two func's who will supply
  // ... the textField arg to each of them.

  // this func merely makes the KB go away, we could survive without it, but later, when we learn to call some magic to force the selected first-responder view to be pushed up above the keyboard which it owns, we will first need to dismis KB from the prior used first responder, so as to uncover the next textField (which may be under the KB owned by the previously used textField at that point).
  func textFieldShouldReturn(textField: UITextField) -> Bool {   // textFieldShouldReturn
    textField.resignFirstResponder()                            // just turning off the textField (first responder) i.e., the textField owns the KB
    return false  // I am told that I should understans that one could have returned true and the effect would be identical
  }

  // when user hits return on soft-KB
  // based on the attached tag (done above), we set the appropriate property of "magic man"(selectedPerson) to textField.text, which
  //... is obviouly being supplied by a caller invoked by virtue of having decalred this class to conform to the aformentioned protocol
  func textFieldDidEndEditing(textField: UITextField) {

    self.cameraMissingAlert.textColor = UIColor.blackColor()
    switch textField.tag {
    case 0:
      self.selectedPerson.firstName = textField.text
    case 1:
      self.selectedPerson.lastName = textField.text
    default:
      break
    }

    if textField.tag == 0 {  // this one line works
      if self.selectedPerson.lastName == "Namath" {  // this one line works
        // the next line always evals to false
        if self.selectedPerson.firstName == "Joe" || self.selectedPerson.firstName == "joe" || self.selectedPerson.firstName == "Joseph"  || self.selectedPerson.firstName == "joe " || self.selectedPerson.firstName == "Joe " {
          self.cameraMissingAlert.textColor = UIColor.redColor()
          self.cameraMissingAlert.text = "Yes, his name is Joe"
/*
          self.view.delete(label)
          self.view.delete(label2)
          self.view.delete(label3)
*/

/*
          var labela = UILabel(frame: CGRectMake(0, 0, 250, 21))
          var labela2 = UILabel(frame: CGRectMake(0, 0, 250, 21))
          var labela3 = UILabel(frame: CGRectMake(0, 0, 250, 21))
          labela.center = CGPointMake(150, 494)
          labela.textAlignment = NSTextAlignment.Center
          labela2.center = CGPointMake(150, 520)
          labela2.textAlignment = NSTextAlignment.Center
          labela3.center = CGPointMake(150, 545)
          labela3.textAlignment = NSTextAlignment.Center
          labela.text = "You got it!"
          labela2.text = "Remember Joe Namath?"
          labela3.text = "And the pantyhose commercial?"
          self.view.addSubview(labela)
          self.view.addSubview(labela2)
          self.view.addSubview(labela3)
*/
          var label = UILabel(frame: CGRectMake(0, 0, 200, 25))
          label.textColor = UIColor.redColor()
          label.center = CGPointMake(210, 575)
          label.text = "You got it!"
          self.view.addSubview(label)
        } else {
          self.cameraMissingAlert.textColor = UIColor.redColor()
          self.cameraMissingAlert.text = "Opps, try again"
        }
      }
    }

  }

  @IBAction func photoButtonPressed(sender: AnyObject) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self // this is how we get the image into our imageView
      imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera // could also be...see below
      //imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary // or, per the following enum
/* // Strange though, how only the last "Word" of each element in the enum is, or can be, used??
      enum {
        UIImagePickerControllerSourceTypePhotoLibrary,
        UIImagePickerControllerSourceTypeCamera,
        UIImagePickerControllerSourceTypeSavedPhotosAlbum
      }
*/ // Also strange that, it being an enum, Xcode complains when I try to use 0, 1, or 2 in place of Camera above. ??

      // it does not seem to make any difference which quality type I use, each fills the entire screen??
      UIImagePickerControllerQualityType.TypeLow // also TypeHigh, TypeLow, Type640x480, TypeIFrame1280x720, TypeIFrame960x540, TypeMedium
      imagePickerController.allowsEditing = true  // if the user crops the image it will return a square image.
      self.presentViewController(imagePickerController, animated: true, completion: nil) // completion could be a closure if we wanted
                                                           // ... to have something additional happen at this point.
    } else {
      // Warn the user of the missing camera in both the sim and the really-old-iPod-touch
      self.cameraMissingAlert.textColor = UIColor.redColor()
      self.cameraMissingAlert.text = "No camera found"
    }
  }
                                                                         // vv external name vv internal name
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject]) {
                                    // dictionaries are also called maps or hash tables in other languages ^^^^^
                                   // ... in fact all dict use hash tables under the hood (an interview question) 
    if let image = info[UIImagePickerControllerEditedImage] as? UIImage {  // returns NSObject AnyObject, hence the down-cast
      // option clicking the ^^^ clicking the doc link, then clicking "Editing Information Keys." shows us the constants we can use ... 
      // ... as alternatives to UIImagePickerControllerEditedImage
      self.imageView.image = image
      // on the sim - option key while pinching on the sim allows cropping
      picker.dismissViewControllerAnimated(true, completion: nil) // again "completion" could have been a closure.
    }
  }
    
}
    /*   Xcode gives the following advice for free, if only Siri were so ... thoughtful:]
    In a storyboard-based application, you will often want to do a little preparation before navigation ...

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    */

