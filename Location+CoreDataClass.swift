








import MapKit
import Foundation
import CoreData

@objc(Location)
public class Location: NSManagedObject,MKAnnotation
{
  public var coordinate: CLLocationCoordinate2D {
    return CLLocationCoordinate2DMake(latitude, longitude)
  }
  public var title: String?
  {
 
      return name
    
  }
  public var subtitle: String? {
    return gender
  }
  
  
  var hasPhoto: Bool {
    return photoID != nil
      }
  var photoURL: URL

{ // spcl dgng tool hega kj k ni
  assert(photoID != nil, "No photo ID set") 
     let filename = "Photo-\(photoID!.intValue).jpg"
    return applicationDocumentsDirectory.appendingPathComponent(
  filename)

  }
  var photoImage: UIImage?
   {
  return UIImage(contentsOfFile: photoURL.path)

    }

  class func nextPhotoID() -> Int {
   let userDefaults = UserDefaults.standard
    let currentID = userDefaults.integer(forKey: "PhotoID") + 1; userDefaults.set(currentID, forKey: "PhotoID"); userDefaults.synchronize()
      return currentID

       }
  func removePhotoFile() {
    if hasPhoto {
  do {
  try FileManager.default.removeItem(at: photoURL)
  } catch {
        print("Error removing file: \(error)")
      }
  } }
  
}
