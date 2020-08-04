//
//  LocationsViewController.swift
//  Cumulus
//
//  Created by Joseph Szafarowicz on 6/27/18.
//  Copyright © 2018 Joseph Szafarowicz. All rights reserved.
//

import UIKit
import CoreData
import GooglePlaces

class LocationsViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet var locationsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var whereabouts: [NSManagedObject] = []
    var saveLocation = ""
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        weatherLoaded = true

        self.navigationController?.navigationBar.topItem?.title = "Locations"
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
        
        // Save Locations
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Places")
        do {
            whereabouts = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let searchBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(autocompleteClicked))
        setupBarButtonColor(button: searchBarButton)
        navigationItem.rightBarButtonItem = searchBarButton
        
        if (defaults.bool(forKey: "userDeniedLocation") == false) {
            let findLocationBarButton = UIBarButtonItem(image: UIImage(systemName: "location.fill"), style: .plain, target: self, action: #selector(LocationsViewController.findCurrentLocation))
            setupBarButtonColor(button: findLocationBarButton)
            navigationItem.leftBarButtonItem = findLocationBarButton
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        autocompleteController.tableCellBackgroundColor = UIColor(named: "customControlColor")!
        autocompleteController.primaryTextColor = UIColor.label
        autocompleteController.secondaryTextColor = UIColor.secondaryLabel
        autocompleteController.primaryTextHighlightColor = UIColor.tertiaryLabel

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func findCurrentLocation(_ sender: UIBarButtonItem) {
        weatherLoaded = false
        userSelectedSavedLocation = false
        selectedLocation = currentLocation
        alertTitle.removeAll()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Home")
        self.present(controller, animated: true, completion: nil)
    }
    
    // Save entered location
    func save(location: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Places", in: managedContext)!
        let places = NSManagedObject(entity: entity, insertInto: managedContext)
        places.setValue(location, forKeyPath: "location")
       
        do {
            try managedContext.save()
            whereabouts.append(places)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension LocationsViewController: GMSAutocompleteViewControllerDelegate {
  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    geocode(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude) { placemark, error in
        guard let placemark = placemark, error == nil else { return }

        // Set state for locations in the US
        if placemark.country! == "United States" {
            self.saveLocation = "\(placemark.locality!), \(placemark.administrativeArea!)"
        } else {
            self.saveLocation = "\(placemark.locality!), \(placemark.country!)"
        }
        let locationToSave = self.saveLocation
        self.save(location: locationToSave)
        self.tableView.reloadData()
        self.navigationController?.isNavigationBarHidden = false
    }
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
}

extension LocationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return whereabouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let places = whereabouts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = places.value(forKeyPath: "location") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        userSelectedSavedLocation = true
        weatherLoaded = false
        let places = whereabouts[indexPath.row]
        selectedLocation = places.value(forKeyPath: "location") as! String
        defaults.set(places.value(forKeyPath: "location") as! String, forKey: "selectedLocation")
        alertTitle.removeAll()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Home")
        self.present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let noteEntity = "Places"
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let places = whereabouts[indexPath.row]
        
        if editingStyle == .delete {
            managedContext.delete(places)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
        }
        
        //Code to Fetch New Data From The DB and Reload Table.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: noteEntity)
        do {
            whereabouts = try managedContext.fetch(fetchRequest) as! [Places]
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
        }
         self.tableView.reloadData()
    }
}