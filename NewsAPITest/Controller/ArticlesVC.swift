//
//  ArticlesVC.swift
//  NewsAPITest
//
//  Created by Martin Grincevschi on 19.07.2018.
//  Copyright © 2018 Martin Grincevschi. All rights reserved.
//

import UIKit
import CoreData



class ArticlesVC: UITableViewController {
    
    private let cellID = "cellID"
    
    var searchController: UISearchController!

    
    lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Article.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "author", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
        self.title = "News Feed"
        view.backgroundColor = .white
        tableView.register(ArticlesCell.self, forCellReuseIdentifier: cellID)
        
        
        updateTableContent()
    }
    
    func updateTableContent() {
        
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(self.fetchedhResultController.sections?[0].numberOfObjects ?? 1)")
        } catch let error  {
            print("ERROR: \(error)")
        }
        
        let service = APIService()
        service.getDataWith { (result) in
            switch result {
            case .Success(let data):
                self.clearData()
                self.saveInCoreDataWith(array: data)
            case .Error(let message):
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: message)
                }
            }
        }
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: title, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ArticlesCell
        
        if let photo = fetchedhResultController.object(at: indexPath) as? Article {
            cell.setArticlesCellWith(photo: photo)
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.width + 100 //100 = sum of labels height + height of divider line
    }
    
    private func createArticleEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let articleEntity = NSEntityDescription.insertNewObject(forEntityName: "Article", into: context) as? Article {
            articleEntity.author = dictionary["author"] as? String
            articleEntity.title = dictionary["title"] as? String
            _ = dictionary["urlToImage"] as? [String: AnyObject]
            articleEntity.mediaURL = dictionary["urlToImage"] as? String
            return articleEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createArticleEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func clearData() {
        do {
            
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Article.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    
    
}


extension ArticlesVC: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}





//MARK: - Search bar methods
extension ArticlesVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("hey")
        tableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print("Should end")
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Will search for" + searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            tableView.reloadData()
            print(searchText)
            return
        }
        
    }

//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
//        filteredTableData.removeAll(keepCapacity: false)
//
//        let searchPredicate = NSPredicate(format: "SELF.infos CONTAINS[c] %@", searchController.searchBar.text!)
//
//        let array = (Article as NSArray).filteredArrayUsingPredicate(searchPredicate)
//
//        for item in array
//        {
//            let infoString = item.infos
//            filteredTableData.append(infoString)
//        }
//
//        self.tableView.reloadData()
//    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    guard !searchText.isEmpty else {
//    tableView.reloadData()
//    print(searchText)
//    return
//    }
//
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
}



