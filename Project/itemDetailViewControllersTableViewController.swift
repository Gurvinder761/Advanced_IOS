

import CoreData
import UIKit

class itemDetailViewController: UITableViewController,UITextViewDelegate
{
  var coreDataStack : CoreDataStack!
  var locationToEdit: Location!
  var country = ""
  var Gender = ""

   var image: UIImage?
  @IBOutlet weak var addPhotoLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  
  @IBOutlet weak var nameshow: UITextField!
  @IBOutlet weak var gendershow: UILabel!
  @IBOutlet weak var countryshow: UILabel!
  @IBOutlet weak var Longitudeshow: UITextField!
  @IBOutlet weak var latitudeshow: UITextField!
  

  @IBOutlet var datePickerCell: UITableViewCell!
  
  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBOutlet weak var dueDateLabel: UILabel!
  
  
  var dueDate = Date()
  
  var datePickerVisible = false
  
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    //  updateDueDateLabel(
    
   if let item = locationToEdit
     {
      title = " Edit Detail"
    // let team = Persons(context: self.coreDataStack.managedContext)
    dueDate = (locationToEdit.birthday!)
    var str = locationToEdit?.name
       nameshow.text = String(str!)
    gendershow.text = locationToEdit.gender
    countryshow.text = locationToEdit.country
     var val = locationToEdit?.subtitle
    
    Longitudeshow.text = String(locationToEdit.longitude)
    latitudeshow.text =  String(locationToEdit.latitude)
    
    
    if locationToEdit.hasPhoto{
      if let theimage = locationToEdit.photoImage
      {
        show(image: theimage)
    
      }
      
    }
    
   }
   else{
    self.navigationItem.rightBarButtonItem?.isEnabled = false
    
   }
    updateDueDateLabel()
  }
    
     
    // MARK: - Table view data source

  // saving the data
  
  
  @IBAction func save(_ sender: Any)
  {
    if locationToEdit != nil
    {
      locationToEdit.country = countryshow.text!
      locationToEdit.name = nameshow.text!
      locationToEdit.gender = gendershow.text!
      locationToEdit.birthday = dueDate
     //team.birthday = dueDateLabel.text! as? NSDate as Date?
       var str1 = Double(latitudeshow.text!)
      if let str1 = Double(latitudeshow.text!){
        locationToEdit.latitude = str1}
      var str2 = Double(Longitudeshow.text!)
      if let str2 = Double(Longitudeshow.text!)
      {
       locationToEdit.longitude = str2
          }
      if let image = image
      {
      locationToEdit.photoID = nil
      
        if !locationToEdit.hasPhoto
       {
    locationToEdit.photoID =  Location.nextPhotoID() as NSNumber
       }
      if let data = UIImageJPEGRepresentation(image , 0.5){

     do{
           try data.write(to: locationToEdit.photoURL, options: .atomic)
          }
     catch
          {
           print("Error writing file: \(error)")
         }
      }
      }
      //
      if ((str1 != nil) && (str2 != nil) && nameshow != nil)  {
   
        self.coreDataStack.saveContext()
        
         navigationController?.popViewController(animated: true)
           }
      else {return}
   
              }

        else
          
        {
    
         let team = Location(context: self.coreDataStack.managedContext)
       
         team.country = countryshow.text!
         team.name = nameshow.text!
         team.gender = gendershow.text!
          team.birthday =  dueDate
          var  str1 = Double(latitudeshow.text!)
            if let str1 = Double(latitudeshow.text!)
            {
              team.latitude = str1
              
            }
         var str2 = Double(Longitudeshow.text!)
            if let str2 = Double(Longitudeshow.text!)
            {
          team.longitude = str2
            }
      

   if let image = image

    {
    team.photoID = nil
      if !team.hasPhoto
        {
    
        team.photoID = Location.nextPhotoID() as NSNumber
            }
      if let data = UIImageJPEGRepresentation(image , 0.5){

        do{   try data.write(to: team.photoURL, options: .atomic)
            } catch {
              print("Error writing file: \(error)")
            }
          }
         }
    
    if ((str1 != nil) && (str2 != nil) && nameshow != nil)
       {
        coreDataStack.saveContext()
        navigationController?.popViewController(animated: true)
      
         }
    else{return}
         
           }
            
             }

    
  @IBAction func Delete(_ sender: Any)
  {
    
    locationToEdit.removePhotoFile()
    coreDataStack.managedContext.delete(locationToEdit)
    do
     {
       try   self.coreDataStack.saveContext()
     
         }
   catch let error as NSError {
   print("Fetch error: \(error) description: \(error.userInfo)")

   }
   
      navigationController?.popViewController(animated: true)
    

  }
  

  func updateDueDateLabel()
      {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            dueDateLabel.text = formatter.string(from: dueDate)

      }
  
  func showDatePicker() {
    
    datePickerVisible = true
        let indexPathDatePicker = IndexPath(row: 1, section: 1)
    tableView.insertRows(at: [indexPathDatePicker], with: .fade)

       dueDateLabel.textColor = view.tintColor
    // psses prpr dte 2 uipckr compo
    datePicker.setDate(dueDate, animated: false)
  }
 
  func hideDatePicker() {
      
    if datePickerVisible
    {
        datePickerVisible = false
          let indexPathDatePicker = IndexPath(row: 1, section: 1)
          dueDateLabel.textColor = UIColor.black
          tableView.beginUpdates()
          tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
          tableView.endUpdates()
          
      }
      
  }
  // unweid for gender
  
  @IBAction func genderpick(
  _ segue: UIStoryboardSegue) {
  let controller = segue.source as! SecondViewController
    Gender = controller.selectgender
    gendershow.text = Gender
  }
  // unweid for country
  @IBAction func countrypick(
  _ segue: UIStoryboardSegue) {
  let controller = segue.source as! CountryViewController
    country = controller.selectcountry
     countryshow.text = country
  }
  
  
  @IBAction func cancel(_ sender: Any)
  {
    navigationController?.popViewController(animated: true)
    
  }
  
  
    
  
  // listen for date picker
  @IBAction func dateChanged(_ datePicker : UIDatePicker)
  {
     dueDate = datePicker.date
     updateDueDateLabel()
      //dueDateLabel.text = dueDate as? String
    
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if section == 1 && datePickerVisible
      {
          return 2
      } else {
          return super.tableView(tableView, numberOfRowsInSection: section)
      }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if indexPath.section == 1 && indexPath.row == 1 {
          return datePickerCell
      } else
      {
          return   super.tableView(tableView, cellForRowAt: indexPath)
      }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if indexPath.section == 1 && indexPath.row == 1
      {
          return 217
      }
      else if indexPath.section == 3
      { // this else if is new
        if imageView.isHidden
        {
        return 80
      }
        else
        {
  return 180
        
        }
        
      }
        else  {
          return  super.tableView(tableView, heightForRowAt: indexPath)
        }
  
      }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
    tableView.deselectRow(at: indexPath, animated: true)
    //  textField.resignFirstResponder()
      
      if indexPath.section == 1 && indexPath.row == 0
      {
          if !datePickerVisible {
              showDatePicker()

          } else {
              hideDatePicker()

          }}
      else if indexPath.section == 3 && indexPath.row == 0
      {
        
       // tableView.deselectRow(at: indexPath, animated: true)
         pickPhoto()
        
      }
           }

  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if indexPath.section == 4 && indexPath.row == 1 && indexPath.row == 0 {
   
        return nil
        
      }
    return indexPath
  }
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    if indexPath.section == 3 && indexPath.row == 0 && locationToEdit != nil
    {
    return true
    }
    else
    {
      return false
    }
         }
      

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
    if  editingStyle  == .delete{
 if locationToEdit != nil
      {

     locationToEdit.removePhotoFile()

        imageView.isHidden = true
         addPhotoLabel.isHidden = false
          tableView.reloadData()
     }
      }
       }

  
  //3rwwhndtapckr vsble dta srce of sttccell
  override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int
  {
       var newIndexPath = indexPath
         if indexPath.section == 1 && indexPath.row == 1
      {
        newIndexPath = IndexPath(row: 0, section: indexPath.section)
     
         }
      
      return super.tableView(tableView, indentationLevelForRowAt: newIndexPath )
  }
  
}






 // image picker
extension itemDetailViewController:
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
func takePhotoWithCamera()
 {
 let imagePicker = UIImagePickerController()
  imagePicker.sourceType = .camera
  imagePicker.delegate = self
  imagePicker.allowsEditing = true
  present(imagePicker, animated: true, completion: nil)
}
  
  
  func choosePhotoFromLibrary()
  {
  let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    present(imagePicker, animated: true, completion: nil)
  }
  
  func pickPhoto() {
    if true || UIImagePickerController.isSourceTypeAvailable( .camera)
    {
      showPhotoMenu()
    } else {
      choosePhotoFromLibrary()
    }
  }
  
  
  func showPhotoMenu()
  {
    let alert = UIAlertController(title: nil, message: nil,
  preferredStyle: .actionSheet)
 
    let actCancel = UIAlertAction(title: "Cancel", style: .cancel,
                              handler: nil)
    let actPhoto = UIAlertAction(title: "Take Photo",  style: .default, handler:{ _ in self.takePhotoWithCamera() })
  
    alert.addAction(actCancel)
    alert.addAction(actPhoto)

    let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in  self.choosePhotoFromLibrary()})
    
                                   
    present(alert, animated: true, completion: nil)
    alert.addAction(actLibrary)
    
  }
  
 
  
    
  func show(image: UIImage)
  {
  imageView.image = image
  imageView.isHidden = false
  imageView.frame = CGRect(x: 10, y: 10, width: 260,
                           height: 260)
    
  addPhotoLabel.isHidden = true
  
  }
  
  // MARK:- Image Picker Delegates
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
  {
 
    image = info[UIImagePickerControllerEditedImage] as? UIImage
  
    if let theImage = image
    
     {
        show(image: theImage)
    }
  
    tableView.reloadData()
    dismiss(animated: true, completion: nil)

    }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
 
  {
    dismiss(animated: true, completion: nil)
  
  
      }
}
