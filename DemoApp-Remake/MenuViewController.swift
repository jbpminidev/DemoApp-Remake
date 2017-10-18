import UIKit

class MenuViewController: UITableViewController {
    
    let defaults = UserDefaults.standard
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            defaults.set("8.mov", forKey: "file")
        case 1:
            defaults.set("7.mov", forKey: "file")
        case 2:
            defaults.set("5s.mp4", forKey: "file")
        case 3:
            defaults.set("5c.mp4", forKey: "file")
        default:
            print("error 1")
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Playback") as! ViewController
        self.present(vc, animated: false, completion: nil)
    }
}
