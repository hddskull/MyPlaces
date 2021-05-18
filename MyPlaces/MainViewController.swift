    //
//  MainViewController.swift
//  MyPlaces
//
//  Created by Gladkov Maxim on 30.03.2021.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var places: Results<Place>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)

        
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.isEmpty ? 0 : places.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        //присваиваем ячейке имя из массива названий

        let place = places[indexPath.row]

        cell.nameLabel?.text = place.name
        cell.locationLabel?.text = place.location
        cell.typeLabel?.text = place.type
        cell.imageOfPlaces.image = UIImage(data: place.imageData!)

        //обрезаем imageView в круг, присваивая ему половину высоты ячейки, тк размер картинки зависит от высоты строки
        cell.imageOfPlaces?.layer.cornerRadius = cell.imageOfPlaces.frame.size.height / 2
        //привязываем изображение к обрезанному view
        cell.imageOfPlaces?.clipsToBounds = true

        return cell
    }
     
    // MARK: - Table View Delegate
    // swipe to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = places[indexPath.row]
            storageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // перед сегвейем по текущей ячейки будет подгружаться информация о месте
        // берем индекс массива выбранной ячейки
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        // присваиваем переменной объект place ячейки
        let place = places[indexPath.row]
        // заводим вьюху формы для нового места
        let newPlaceVC = segue.destination as! NewPlaceViewController
        // в перменную currentPlace вставим данные из ячейки
        newPlaceVC.currentPlace = place
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
}
