

import MapKit
 import UIKit
  import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate
  
   {
  
      var coreDataStack : CoreDataStack!
    
      lazy var fetchedResultsController: NSFetchedResultsController<Location> = {
      let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
    
      let zoneSort = NSSortDescriptor(key: #keyPath(Location.name), ascending: true)
      fetchRequest.sortDescriptors = [zoneSort]

      let fetchedResultsController = NSFetchedResultsController(
        fetchRequest: fetchRequest,
        managedObjectContext: coreDataStack.managedContext,
        sectionNameKeyPath: #keyPath(Location.name),
        cacheName: "Model")

      fetchedResultsController.delegate = self

      return fetchedResultsController
    }()
    
    
    
    


       @IBOutlet weak var MapView: UIView!
       @IBOutlet weak var List: UIView!
       @IBOutlet weak var DoneBarButton: UIBarButtonItem!
    

 
  
  
  
  override func viewDidLoad()
  {
  super.viewDidLoad()
  performfetch()
  }
  
  
  func performfetch()
  {
  do
     {
    try fetchedResultsController.performFetch()
      }
    catch let error as NSError
     {
       print("Fetching error: \(error), \(error.userInfo)")
      }
  do {
      try   coreDataStack.managedContext.save()
      }
    catch let error as NSError
      {
        print("Saving error: \(error), description: \(error.userInfo)")
      }
  }
  

 
  @IBAction  func switchview(sender: UISegmentedControl)
  {
   
      if sender.selectedSegmentIndex == 0
          {
            List.alpha = 0
            MapView.alpha = 1
          }
   else
         {
          List.alpha = 1
          MapView.alpha = 0
         }
    }
    @IBAction func done(_ sender: Any)
    {
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

      if ( segue.identifier == "editscreen")
      {
      let navController = segue.destination as? itemDetailViewController

      navController!.coreDataStack = coreDataStack

      }
     else if ( segue.identifier == "tomap")
     {

      let navController = segue.destination as? MapViewController

       navController!.coreDataStack = coreDataStack

     }
     else if ( segue.identifier == "tolist")
     {

      let navController = segue.destination as? ListViewController
     
      navController?.coreDataStack = coreDataStack

     }

    
    }
      }


