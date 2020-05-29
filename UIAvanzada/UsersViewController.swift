//
//  UsersViewController.swift
//  UIAvanzada
//
//  Created by David Rabassa Planas on 26/05/2020.
//  Copyright © 2020 David Rabassa. All rights reserved.
//

import UIKit

enum UsersError: Error {
    case emptyData
}

class UsersViewController: UIViewController {
    
    // En vez de crear una tabla, creamos un CollectionView
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var usuariosTitle: UILabel!
    
    var users: [Users] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usuariosTitle.font = .largeTitle2Bold1Light1LabelColor1LeftAligned
        
        // Registramoas la celda UsersCollectionViewCell.xib
        collectionView.register(UINib(nibName: "UsersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UsersCollectionViewCell")
        collectionView.dataSource = self // el DataSource somos nosotros
        
       
        // Recuperar el FlowLayout del CollectionView y configurarlo
        configurarCollectionView()
        
        
        
        
        
        fetch { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.collectionView.reloadData()
              //  self?.usersTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configurarCollectionView() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        // Aquí configuramos
        flowLayout.sectionInset = UIEdgeInsets(top: 26, left: 26, bottom: 26, right: 26)
        flowLayout.minimumInteritemSpacing = 20.5
        flowLayout.itemSize = CGSize(width: 94, height: 124)
        flowLayout.estimatedItemSize = .zero
        flowLayout.minimumLineSpacing = 18
        
    }
    
    func fetch(completion: @escaping (Result<[Users], Error>) -> Void){
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        guard let url = URL(string:"https://mdiscourse.keepcoding.io/directory_items.json?period=all") else { fatalError() }

        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let data = data {
                    guard let UsersListResponse = try? JSONDecoder().decode(UsersListResponse.self, from: data) else {
                        completion(.failure(UsersError.emptyData))
                        return
                    }
                    completion(.success(UsersListResponse.directoryItems))
                }
            }
        }
        task.resume()
    }
    
    
} // End


extension UsersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsersCollectionViewCell", for: indexPath) as? UsersCollectionViewCell else { fatalError() }
        let user = users[indexPath.row]
        cell.usersNameLabel.text = users[indexPath.row].user.username
       
        // Carga de imagen
        DispatchQueue.global(qos:.userInitiated).async { [weak self] in
            if let avatarTemplate = self?.users[indexPath.row].user.avatarTemplate {
                let sized = avatarTemplate.replacingOccurrences(of: "{size}", with: "150")
                let usersURL = "https://mdiscourse.keepcoding.io\(sized)"
                guard let url = URL(string: usersURL),
                    let data = try? Data(contentsOf: url) else {return}
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    cell.usersImageView?.image = image
                    cell.setNeedsLayout()
                }
            }
        }
        return cell
    }
} // End Struct



// Lo tengo a parte en Model/User.swift porque lo necesito utiulizar en este
// controlador y en ViewController
/*
 struct UsersListResponse: Codable {
     let directoryItems: [Users]
     enum CodingKeys: String, CodingKey {
         case directoryItems = "directory_items"
     }
 }
 
 struct Users: Codable {
     let user: User
     
 }

 struct User: Codable {
     let username: String
     let name: String?
     let avatarTemplate: String
     
     enum CodingKeys: String, CodingKey {
         case avatarTemplate = "avatar_template"
         case username
         case name
     }
 }
 */




