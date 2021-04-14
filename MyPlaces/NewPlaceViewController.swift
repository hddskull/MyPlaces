//
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Gladkov Maxim on 14.04.2021.
//

import UIKit

class NewPlaceViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView() 

    }

    //MARK: table View delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        }
        else {
            view.endEditing(true)
        }
    }
}

//MARK: text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    // скрываем клаву по нажатию кнопки done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


