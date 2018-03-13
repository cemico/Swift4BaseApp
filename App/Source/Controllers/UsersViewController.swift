//
//  UsersViewController.swift
//  S4BA
//
//  Created by Dave Rogers on 3/4/18.
//  Copyright © 2018 Cemico. All rights reserved.
//

import UIKit

class UsersViewController: BaseViewController {

    ///////////////////////////////////////////////////////////
    // outlets
    ///////////////////////////////////////////////////////////

    @IBOutlet weak var tableView: UITableView!

    ///////////////////////////////////////////////////////////
    // variables
    ///////////////////////////////////////////////////////////

    // convert dict into (k,v) sorted array
    private lazy var users: [(key: String, value: String)] = Settings.users.sorted(by: <)

    ///////////////////////////////////////////////////////////
    // system overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    ///////////////////////////////////////////////////////////
    // actions
    ///////////////////////////////////////////////////////////

    @IBAction func onAddUser(_ sender: UIBarButtonItem) {
    }
}

///////////////////////////////////////////////////////////
// Localize Protocol
///////////////////////////////////////////////////////////

extension UsersViewController: LocalizeProtocol {

    func localize() {

        // localize this screen
    }
}

///////////////////////////////////////////////////////////
// UITableViewDataSource
///////////////////////////////////////////////////////////

extension UsersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // guaranteed cell
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.className, for: indexPath)

        // make custom mods
        if let cell = cell as? UserTableViewCell {

            // get data
            let data = users[indexPath.row]
            cell.name.text = data.key
        }

        return cell
    }
}

///////////////////////////////////////////////////////////
// UITableViewDelegate
///////////////////////////////////////////////////////////

extension UsersViewController: UITableViewDelegate {

}

///////////////////////////////////////////////////////////
// UserTableViewCell
///////////////////////////////////////////////////////////

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hashKey: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
