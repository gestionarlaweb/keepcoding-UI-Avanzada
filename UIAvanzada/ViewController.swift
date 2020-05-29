//
//  ViewController.swift
//  UIAvanzada
//
//  Created by David Rabassa Planas on 23/05/2020.
//  Copyright © 2020 David Rabassa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{ // , topicDelegate
    
    //CONCURRENCIA
   // protocol topicDelegate {
   //     func refreshView()
   // }
    enum LatestTopicsError: Error {
        case malformedURL // Si la url esta mal
        case emptyData
    }
    
    var topics: [Topic] = []
    
    // Para la imagen
    var users: [Users] = []
    
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
        
        // Configuración del tamaño de la celda usersTopics
        //configurarTableView()
        
      
        // Por último la llamada
        fetchTopics { [weak self] (result) in
            switch result {
            case .success(let let_topics):
                self?.topics = let_topics
                self?.tableView.reloadData()
            case .failure(let error):
                self?.showErrorAlert(message: error.localizedDescription)
                // También si no quieres poner el showErrorAlert
                // le pones un
                print(error)
            }
        }
        // Ejecuta el RefereshControl
        tableView.refreshControl = refreshControl
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
               cell.textUserTopic.text = topics[indexPath.row].title
               cell.postsCountLabel.text = String(topics[indexPath.row].posts_count)
               
               // TITLE and Num Topics
               
               cell.textUserTopic.text = topics[indexPath.row].title
               cell.postsCountLabel.text = String(topics[indexPath.row].posts_count)
               
               // DATE
               
               var myString_date: String
               myString_date = topics[indexPath.row].last_posted_at
               
               let inputStringDate = myString_date
               let inputFormat = "YYYY-MM-DD'T'HH:mm:ss.SSSZ"
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
               
               // IMAGE AVATAR
               /*
                DispatchQueue.global(qos:.userInitiated).async { [weak self] in
                if let avatarTemplate = self?.users[indexPath.row].user.avatarTemplate {
                let sized = avatarTemplate.replacingOccurrences(of: "{size}", with: "150")
                let usersURL = "https://mdiscourse.keepcoding.io\(sized)"
                guard let url = URL(string: usersURL),
                let my_data = try? Data(contentsOf: url) else {return}
                let image = UIImage(data: my_data)
                
                DispatchQueue.main.async {
                cell.avatarUserTopic?.image = image
                cell.setNeedsLayout()
                }
                }
                }
                */
               return cell
           }
        }
        
        
        
        
        fatalError("Could not create Account cells")
        
        
    }
        
       
    
    func my_date(){
        // Fecha del topic
       
            let inputStringDate = "2020-04-20T00:00:00.000Z"
            //let inputStringDate = myString_date
            let inputFormat = "YYYY-MM-DD'T'HH:mm:ss.SSSZ"
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "es_ES")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = inputFormat
        
        // Generar la fecha a partir del string y el formato de entrada
       // guard let my_date = dateFormatter.date(from: inputStringDate) else { return }
        let my_date = dateFormatter.date(from: inputStringDate)!
            
            // May 2020
            var outputFormat = "MMM yyyy"
            dateFormatter.dateFormat = outputFormat
        var outputStringDate = dateFormatter.string(from: my_date)
        print(outputStringDate)
    }
    
    // MARK: - UITableViewDelegate
    /*
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
     let topic = topics[indexPath.row]
     // withId : -> convenience
     let topicsDetailVC = DetailTopicViewController.init(withId: topic.id)
     topicsDetailVC.delegate = self
     let navigationController = UINavigationController(rootViewController: topicsDetailVC)
     navigationController.modalPresentationStyle = .fullScreen
     self.present(navigationController, animated: true, completion: nil)
     
     tableView.deselectRow(at: indexPath, animated: true)
     }
     
     */
    
    
    
    
    // Necesitará del protocolo de más arriba
    /*
     func refreshView() {
         fetchTopics { [weak self] (result) in
             switch result {
             case .success(let latestTopics):
                 self?.topics = latestTopics
                 self?.tableView.reloadData()
             case .failure(let error):
                 print(error)
                 self?.showErrorAlert(message: error.localizedDescription)
             }
         }
     }
     */
    
        
        
    
    
    
    
    
    
    
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
    let posts_count: Int
    let last_posted_at: String
    
}





// BACKUP
/*
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     
     guard let cell = tableView.dequeueReusableCell(withIdentifier: "TopicsViewCell", for: indexPath) as? TopicsViewCell else {
         fatalError()}
     cell.textUserTopic.text = topics[indexPath.row].title
     cell.postsCountLabel.text = String(topics[indexPath.row].posts_count)
     
     // TITLE and Num Topics
     
     cell.textUserTopic.text = topics[indexPath.row].title
     cell.postsCountLabel.text = String(topics[indexPath.row].posts_count)
     
     // DATE
     
     var myString_date: String
     myString_date = topics[indexPath.row].last_posted_at
     
     let inputStringDate = myString_date
     let inputFormat = "YYYY-MM-DD'T'HH:mm:ss.SSSZ"
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
     
     // IMAGE AVATAR
     /*
      DispatchQueue.global(qos:.userInitiated).async { [weak self] in
      if let avatarTemplate = self?.users[indexPath.row].user.avatarTemplate {
      let sized = avatarTemplate.replacingOccurrences(of: "{size}", with: "150")
      let usersURL = "https://mdiscourse.keepcoding.io\(sized)"
      guard let url = URL(string: usersURL),
      let my_data = try? Data(contentsOf: url) else {return}
      let image = UIImage(data: my_data)
      
      DispatchQueue.main.async {
      cell.avatarUserTopic?.image = image
      cell.setNeedsLayout()
      }
      }
      }
      */
     return cell
 }
 */
