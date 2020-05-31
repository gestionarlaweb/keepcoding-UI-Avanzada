//
//  ViewController.swift
//  UIAvanzada
//
//  Created by David Rabassa Planas on 23/05/2020.
//  Copyright © 2020 David Rabassa. All rights reserved.
//

import UIKit

protocol topicDelegate {
    func refreshView()
}

enum LatestTopicsError: Error {
    case malformedURL // Si la url esta mal
    case emptyData
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, topicDelegate {
    
    var topics: [Topic] = []
    
    // Para la imagen
   var users: [User] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    // Para el título TEMAS
    @IBOutlet weak var temasLabel: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Config label TEMAS
        temasLabel.font = .largeTitle2Bold1Light1LabelColor1LeftAligned
        
        tableView.dataSource = self
        tableView.delegate = self
        
       
        // Registramoas la celda WelcomViewCell.xib
        tableView.register(UINib(nibName: "WelcomViewCell", bundle: nil), forCellReuseIdentifier: "WelcomViewCell")
        
        // Registramoas la celda TopicsViewCell.xib
        tableView.register(UINib(nibName: "TopicsViewCell", bundle: nil), forCellReuseIdentifier: "TopicsViewCell")
        
        // refreshView()
        refreshView()
        
        // Ejecuta el RefereshControl
        tableView.refreshControl = refreshControl
    }
    func refreshView() {
        fetchTopics { [weak self] (result) in
            switch result {
            case .success(let let_topics):
                self?.topics = let_topics
                // self?.users = latestTopicsResponse.users
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showErrorAlert(message: error.localizedDescription)
                // También si no quieres poner el showErrorAlert
                // le pones un
                print(error)
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Cargando datos")
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        return refreshControl
    }()
    // parar la animación de RefreshControl
    @objc func refreshControlPulled() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
    }
    
    
    
    // MARK: - UITableViewDatasource
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
           if let cell = tableView.dequeueReusableCell(withIdentifier: "WelcomViewCell", for: indexPath) as? WelcomViewCell {
               return cell
           }
        }
        if indexPath.row > 0 {
           if let cell = tableView.dequeueReusableCell(withIdentifier: "TopicsViewCell", for: indexPath) as? TopicsViewCell {
             
               // TITLE and Num Topics
               cell.textUserTopic.text = topics[indexPath.row].title
               cell.postsCountLabel.text = String(topics[indexPath.row].postsCount)
            
            // IMAGE AVATAR - Pendiente
            
            // Para la imagen
          // Pendiente. No se desarrollarlo
            /*
             Entiendo que debe ser algo como username(de User) == lastPosterUsername(de Topic)
             y que si es igual me devuelvas un return user
             a partir de aquí ya me lio con como dibujar la imagen
             
             */
            
               
               // DATE
               
               var myString_date: String
               myString_date = topics[indexPath.row].lastPostedAt
               
               let inputStringDate = myString_date
               let inputFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
               let dateFormatter = DateFormatter()
               dateFormatter.locale = Locale(identifier: "es_ES")
               dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
               dateFormatter.dateFormat = inputFormat
               
               // Generar la fecha a partir del string y el formato de entrada
               let my_date = dateFormatter.date(from: inputStringDate)!
               // May 2020
               let outputFormat = "MMM yyyy"
               dateFormatter.dateFormat = outputFormat
               let outputStringDate = dateFormatter.string(from: my_date)
               cell.lastPostedAtLabel.text = outputStringDate
               
               return cell
           }
        }
        fatalError("Could not create Account cells")
    }
   
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let idCeldaSeleccionada = indexPath.row
        self.performSegue(withIdentifier: "segueDetalle", sender: idCeldaSeleccionada)
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
     
    // MARK: override func SEGUE
    // Pasar los datos de una pantalla a otra
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueDetalle") {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                guard let destinationVC = segue.destination as? DetailTopicViewController else { return }
                // Aquí los datos a recibir del otro controlador
              // PENDIENTE
                // Porque no me funciona ????
                //  destinationVC.topic = topics[indexPath.row]
            }
        }
        
    }
    
        func showErrorAlert(message: String) {
                let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            
            //Muestra Request
                
                // conexión a la url
                func fetchTopics(completion: @escaping (Result<[Topic], Error>) -> Void) {
                    guard let usersURL = URL(string: "https://mdiscourse.keepcoding.io/latest.json") else {
                        completion(.failure(LatestTopicsError.malformedURL))
                        return
                    }

                    // Crear la session
                    let configuration = URLSessionConfiguration.default
                    let session = URLSession(configuration: configuration)

                    // Crear la request
                    var request = URLRequest(url: usersURL)
                    request.httpMethod = "GET" // Obtener
                    // Nos podemos validar de varias formas. En este ejemplo vamos ha hacerlo con un ApiKey y un nombre de usuario
                    request.addValue("699667f923e65fac39b632b0d9b2db0d9ee40f9da15480ad5a4bcb3c1b095b7a", forHTTPHeaderField: "Api-Key")
                    request.addValue("gestionarlaweb", forHTTPHeaderField: "Api-Username")
                    
                    let dataTask = session.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            // Si error
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                            return
                        }
                        // Si no hay dados
                        guard let data = data else {
                            DispatchQueue.main.async {
                                completion(.failure(LatestTopicsError.emptyData))
                            }
                            return
                        }
                        // Si no hay error y hay datos
                        do {
                            let response = try JSONDecoder().decode(StructResultTopics.self, from: data)
                            DispatchQueue.main.async {
                                // ESTA LÍNEA ES LA QUE VALE LA PENA MIRARSELA UN BUEN RATO !
                                completion(.success(response.topicList.topics))
                            }
                            // en caso de error en la carga de datos (corte de conexión por ejemplo)
                        } catch(let error) {
                            DispatchQueue.main.async {
                                completion(.failure(error))
                            }
                        }
                    }

                    dataTask.resume()
                }
        }



 struct StructResultTopics: Codable {
     let topicList: TopicList
     let users: [User]  // Para la imagen
     enum CodingKeys: String, CodingKey {
         case topicList = "topic_list"
         case users  // Para la imagen
     }
 }


 struct TopicList: Codable {
     let topics: [Topic]
 }

 struct Topic: Codable {
     let id: Int
     let title: String
     let postsCount: Int
     let lastPostedAt: String
     let lastPosterUsername: String
     let posters: [Poster]
     enum CodingKeys: String, CodingKey {
         case id
         case title
         case postsCount = "posts_count"
         case lastPostedAt = "last_posted_at"
         case posters
         case lastPosterUsername = "last_poster_username"
     }
 }

 struct Poster: Codable {
     let description: String
     let user_id: Int
 }
 
/*
struct StructResultTopics: Codable {
    let topicList: TopicList
    enum CodingKeys: String, CodingKey {
        case topicList = "topic_list"
    }
}

struct TopicList: Codable {
    let topics: [Topic]
}

struct Topic: Codable {
    let id: Int
    let title: String
    
}
 */

