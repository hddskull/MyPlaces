 //
//  NewPlaceViewController.swift
//  MyPlaces
//
//  Created by Gladkov Maxim on 14.04.2021.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    // переменная где будут храниться данные по определенной ячейки
    var currentPlace: Place?
    
    var newPlace = Place()
    var imageIsChanged = false

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        tableView.tableFooterView = UIView()
        
        saveButton.isEnabled = false
        //метод для отслеживания поля на изменения, в селекторе используется кастомный метод для проверки поля на наличие символа
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()

    }

    //MARK: table View delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let imageIcon = #imageLiteral(resourceName: "photo")
            let cameraIcon = #imageLiteral(resourceName: "camera")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
                self.chooseImagePicker(source: UIImagePickerController.SourceType.camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { (_) in
                self.chooseImagePicker(source: UIImagePickerController.SourceType.photoLibrary)
            }
            photo.setValue(imageIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
        }
        else {
            view.endEditing(true)
        }
    }
     
    func savePlace() {
                
        var image: UIImage?
        
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = #imageLiteral(resourceName: "imagePlaceholder")
        }
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData)
        // если текущий объект есть, то это экран редактирования и нужно присваивать данные полученные из аутлетов
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.type = newPlace.location
                currentPlace?.location = newPlace.type
                currentPlace?.imageData = newPlace.imageData
            }
        } else {
            // если объекта места нет, то создаем новый
            storageManager.saveObject(newPlace)
        }
        
    }
    
    private func setupEditScreen(){
        // проверка на то что ячейка тыкнутая не nil
        if currentPlace != nil {
            
            setupNavigationBar()
            // чтобы изображение при редактировании не сбрасывалось, то нужно указать что изобр изменено, что не подставилось дефолтное
            imageIsChanged = true
            
            // проверяем что из переменой извлекается дата по изображению и присваеваем переменной image изображение собранное из data
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            // присваеваем outlet'ам данные из переменной и изображение
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            placeType.text = currentPlace?.type
            placeLocation.text = currentPlace?.location
        }
    }
    
    private func setupNavigationBar() {
        // меняем навзвание кнопки с My places на просто стрелку (подставляем пустую строку)
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        // меняем заголовок на ресторанный, кнопку сохр вкл, меняет левую кнопку на дефолтную назад
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
}

//MARK: text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    // скрываем клаву по нажатию кнопки done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // проверка есть ли символ в поле placeName
    @objc private func textFieldChanged() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

//MARK: image in new cell

extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType)  {
        
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate =  self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}

