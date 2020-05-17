//
//  SiriShortcutsTableViewController.swift
//  Cumulus
//
//  Created by Joseph Szafarowicz on 10/5/18.
//  Copyright © 2018 Joseph Szafarowicz. All rights reserved.
//

import UIKit
import Intents
import IntentsUI
import os.log

class SiriShortcutsTableViewController: UITableViewController {

    @IBOutlet weak var currentForecastButton: UIButton!
    @IBOutlet weak var tableViewCell: UITableViewCell!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        weatherLoaded = true
        
        self.navigationItem.title = "Siri Shortcuts"
        self.navigationController?.navigationBar.topItem?.title = ""
        
        if defaults.string(forKey: "userSavedColorString") == "Mandarin" {
            self.navigationController?.navigationBar.tintColor = mandarin
        } else if defaults.string(forKey: "userSavedColorString") == "Malachite" {
            self.navigationController?.navigationBar.tintColor = malachite
        } else if defaults.string(forKey: "userSavedColorString") == "Maximum Red" {
            self.navigationController?.navigationBar.tintColor = maximumRed
        } else if defaults.string(forKey: "userSavedColorString") == "Dodger Blue" {
            self.navigationController?.navigationBar.tintColor = dodgerBlue
        } else if defaults.string(forKey: "userSavedColorString") == "Plump Purple" {
            self.navigationController?.navigationBar.tintColor = plumpPurple
        } else if defaults.string(forKey: "userSavedColorString") == "Sandstorm" {
            self.navigationController?.navigationBar.tintColor = sandstorm
        } else if defaults.string(forKey: "userSavedColorString") == "Asteroid" {
            self.navigationController?.navigationBar.tintColor = asteroid
        } else if defaults.string(forKey: "userSavedColorString") == "Carmine Pink" {
            self.navigationController?.navigationBar.tintColor = carminePink
        } else {
            self.navigationController?.navigationBar.tintColor = dodgerBlue
        }
        
        tableView.tableFooterView = UIView(frame: .zero)

        // Intent Siri Button
        let intent = ForecastIntent()
        let addShortcutButton = INUIAddVoiceShortcutButton(style: .white)
        addShortcutButton.shortcut = INShortcut(intent: intent)
        addShortcutButton.delegate = self
        
        let margins = tableViewCell.layoutMarginsGuide
        addShortcutButton.translatesAutoresizingMaskIntoConstraints = false
        tableViewCell.addSubview(addShortcutButton)

        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        if screenHeight <= 700 {
            // iPhone SE
            addShortcutButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
            addShortcutButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 200).isActive = true
        } else if screenHeight > 900 {
            addShortcutButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
            addShortcutButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 575).isActive = true
        } else {
            addShortcutButton.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
            addShortcutButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 175).isActive = true
        }
        donateInteraction()
    }
    
    func donateInteraction() {
        let intent = ForecastIntent()
        intent.suggestedInvocationPhrase = "Get forecast"
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as NSError? {
                    os_log("Interaction donation failed: %@", log: OSLog.default, type: .error, error)
                }
            } else {
                os_log("Successfully donated interaction")
            }
        }
    }
}

extension SiriShortcutsTableViewController: INUIAddVoiceShortcutButtonDelegate {
    
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    /// - Tag: edit_phrase
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
}

extension SiriShortcutsTableViewController: INUIAddVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                        didFinishWith voiceShortcut: INVoiceShortcut?,
                                        error: Error?) {
        if let error = error as NSError? {
            os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
        }
        
        // Get user phrase
        defaults.set("\"\(voiceShortcut?.invocationPhrase ?? "")\"", forKey: "userInvocationPhrase")
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension SiriShortcutsTableViewController: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didUpdate voiceShortcut: INVoiceShortcut?,
                                         error: Error?) {
        if let error = error as NSError? {
            os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
        }
        
        // Get user phrase
        defaults.set("\"\(voiceShortcut?.invocationPhrase ?? "")\"", forKey: "userInvocationPhrase")
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
