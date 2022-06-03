//
//  MoviesViewController.swift
//  FireBase
//
//  Created by mac16 on 02/06/22.
//

import UIKit
import CoreData

class MoviesViewController: UIViewController {
    // MARK: - Conexion a la BD o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var arregloPeliculas=[Pelicula]()
    var peliculaEnviar: Pelicula?
    
    @IBOutlet weak var listaPeliculas: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Delegados
        listaPeliculas.delegate = self
        listaPeliculas.dataSource = self
        
        //Leer info de la base de datos
        leerPeliculas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        leerPeliculas()
    }
    
    func leerPeliculas(){
        let solicitud: NSFetchRequest<Pelicula> = Pelicula.fetchRequest()
        do {
            //Guardar en el arreglo los datos de la entidad tarea
            arregloPeliculas = try contexto.fetch(solicitud)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        listaPeliculas.reloadData()
    }

}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arregloPeliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = listaPeliculas.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        celda.textLabel?.text = arregloPeliculas[indexPath.row].titulo
        celda.detailTextLabel?.text = arregloPeliculas[indexPath.row].lanzamiento
        celda.imageView?.image = UIImage(data: arregloPeliculas[indexPath.row].poster!)
        celda.imageView?.layer.cornerRadius = 15
        return celda
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "Borrar") { (_, _, _) in
            self.contexto.delete(self.arregloPeliculas[indexPath.row])
            self.arregloPeliculas.remove(at: indexPath.row)
            
            do {
                try self.contexto.save()
                print("Datos guardados en coredata")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            self.listaPeliculas.reloadData()
        }
        accionEliminar.image = UIImage(systemName: "trash.fill")
        accionEliminar.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
}
