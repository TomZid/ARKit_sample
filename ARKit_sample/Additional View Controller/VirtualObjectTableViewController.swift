//
//  VirtualObjectTableViewController.swift
//  ARKit_sample
//
//  Created by Tom.Zid on 12/09/2017.
//  Copyright © 2017 TZ. All rights reserved.
//

import UIKit

class VirtualObjectTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .light))
    }
    
    override func viewWillLayoutSubviews() {
        self.preferredContentSize = CGSize(width: 230, height: tableView.contentSize.height)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return VirtualObjectManager.availableObjects.count;
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let object = VirtualObjectManager.availableObjects[indexPath.row]
        cell.textLabel?.text = object.displayName
//        cell.imageView?.image = object.thumbImage

        return cell
    }

}
