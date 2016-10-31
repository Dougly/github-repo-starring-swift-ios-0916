//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    let alert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        
        
        store.getRepositoriesWithCompletion {
            OperationQueue.main.addOperation({ 
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRepo = store.repositories[indexPath.row]
        
        ReposDataStore.toggleStarStatus(for: selectedRepo) { (toggleOnOff) in
            switch toggleOnOff {
            case true:
                self.alert.accessibilityLabel = "You just starred \(selectedRepo.fullName)"
                self.alert.message = "You just starred \(selectedRepo.fullName)"
                print ("starred the repo")
            case false:
                self.alert.accessibilityLabel = "You just unstarred \(selectedRepo.fullName)"
                self.alert.message = "You just unstarred \(selectedRepo.fullName)"
                print ("unstarred the repo")
            }
        }
        
        
    }

}
