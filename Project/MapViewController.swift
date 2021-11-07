

 import MapKit
  import UIKit
   import CoreData

class MapViewController: UIViewController,MKMapViewDelegate, NSFetchedResultsControllerDelegate
   
{

   
     var coreDataStack: CoreDataStack!
     {
       didSet  {
         NotificationCenter.default.addObserver(forName: Notification.Name.NSManagedObjectContextObjectsDidChange, object: coreDataStack.managedContext ,
     queue: OperationQueue.main)
     {
       notification in
     if self.isViewLoaded
     {
     
     self.updatelocations()
    //   self.mapView.reloadInputViews()
       }
           if let dictionary = notification.userInfo
           { print(dictionary["inserted"])
             print(dictionary["deleted"])
             print(dictionary["updated"])
             }
        }
    }
}
     

       var locations = [Location]()

lazy var fetchedResultsController: NSFetchedResultsController<Location> = {

let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
let zoneSort = NSSortDescriptor(key: #keyPath(Location.name), ascending: false)
fetchRequest.sortDescriptors = [zoneSort]


let fetchedResultsController = NSFetchedResultsController( fetchRequest: fetchRequest,managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil,
  cacheName: nil)
fetchedResultsController.delegate = self
return fetchedResultsController
}()


  @IBOutlet weak var mapView: MKMapView!

  // var coreDataStack: CoreDataStack!


override func viewDidLoad()
   {
       super.viewDidLoad()
      
      
   updatelocations()
  
      }
  

  
    @objc func showLocationDetails(_ sender: UIButton)
        {
      
      performSegue(withIdentifier: "additem", sender: sender)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
            {

               if (segue.identifier == "additem")
                {
              let navController = segue.destination as? itemDetailViewController
              

                navController?.coreDataStack = coreDataStack
         let button = sender as! UIButton
         let location = locations[button.tag]
    
          navController!.locationToEdit = location
          
           
              }
        }
          
  
  
func updatelocations()

 {
  do {
     try fetchedResultsController.performFetch()
         }
         catch let error as NSError {
           print("Fetching error: \(error), \(error.userInfo)")

               }

    mapView.removeAnnotations(locations)

    locations = try! fetchedResultsController.fetchedObjects!
  
    mapView.addAnnotations(locations)

    }

      }

extension MapViewController
  {
       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
      {
// 1
      guard annotation is Location
            else
                 {
                   return nil
                   }
// 2
      let identifier = "Location"
      var annotationView = mapView.dequeueReusableAnnotationView(
                                   withIdentifier: identifier)
  if annotationView == nil
    {
    let pinView = MKPinAnnotationView(annotation: annotation,reuseIdentifier: identifier)
    
     pinView.isEnabled = true
     pinView.canShowCallout = true
     pinView.animatesDrop = false
     pinView.pinTintColor = UIColor(red: 0.32, green: 0.82,blue: 0.4, alpha: 1)
// 4
         let rightButton = UIButton(type: .detailDisclosure)
    
          rightButton.addTarget(self,action: #selector(showLocationDetails), for: .touchUpInside)
          pinView.rightCalloutAccessoryView = rightButton
         
             annotationView = pinView
           }
  
    if let annotationView = annotationView
     {
          annotationView.annotation = annotation
// 5
          let button = annotationView.rightCalloutAccessoryView as! UIButton
     
          if let index = locations.index(of: annotation as! Location)
      
                  {
                      button.tag = index
        
                  }
            
              }
  
            return annotationView
  
          }

      }
