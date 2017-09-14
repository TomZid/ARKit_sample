/**
 * error message -----------------> 'weak' may only be applied to class and class-bound protocol types
 * answer:
 weak is a qualifier for reference types (as opposed to value types, such as structs and built-in value types).
 
 Reference types let you have multiple references to the same object. The object gets deallocated when the last strong reference stops referencing it (weak references do not count).
 
 Value types, on the other hand, are assigned by copy. Reference counting does not apply, so weak modifier does not make sense with them.
 */

import UIKit

protocol VirtualObjectTableViewControllerDelegate: NSObjectProtocol {
    func virtualObjectTableViewController(_: VirtualObjectTableViewController, didselectObjectAt index: Int)
    func virtualObjectTableViewController(_: VirtualObjectTableViewController, didDeselectObjectAtindex: Int)
}

class VirtualObjectTableViewController: UITableViewController {

    private var selectedVirtualObjectRows = IndexSet()
    weak var delegate: VirtualObjectTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
    }
    
    override func viewWillLayoutSubviews() {
        self.preferredContentSize = CGSize(width: 230, height: tableView.contentSize.height)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VirtualObjectManager.availableObjects.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        var object = VirtualObjectManager.availableObjects[indexPath.row]
        cell.textLabel?.text = object.displayName
        cell.imageView?.image = object.thumbImage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        if selectedVirtualObjectRows.contains(indexPath.row) {
            delegate?.virtualObjectTableViewController(self, didDeselectObjectAtindex: indexPath.row)
        }else {
            delegate?.virtualObjectTableViewController(self, didselectObjectAt: indexPath.row)
        }
        self.dismiss(animated: true, completion: nil)
    }

}
