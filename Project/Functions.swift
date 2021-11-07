

import Foundation

let applicationDocumentsDirectory: URL = {
let paths = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)
     return paths[0]
}()

