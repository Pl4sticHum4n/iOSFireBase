//
//  ListaSongsViewController.swift
//  FireBase
//
//  Created by mac16 on 27/05/22.
//

import UIKit
import CoreData

class ListaSongsViewController: UIViewController, UISearchBarDelegate{
    // MARK: - Conexion a la BD o al contexto
    let contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tituloLbl: UILabel!
    @IBOutlet weak var generoLblb: UILabel!
    @IBOutlet weak var duracionLblb: UILabel!
    @IBOutlet weak var paisLbl: UILabel!
    @IBOutlet weak var lanzamientoLbl: UILabel!
    @IBOutlet weak var posterIV: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        // Do any additional setup after loading the view.

        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let pelicula = searchBar.text{
            print(pelicula)
            let urlString = "http://www.omdbapi.com/?apikey=99cc4d2d&t=\(pelicula)"
            
            if let url = URL(string: urlString){
                let sesion = URLSession(configuration: .default)
                
                let tarea = sesion.dataTask(with: url) { (datos, respuesta, error) in
                    if error != nil {
                        print("Error al buscar informacion: \(error?.localizedDescription)")
                    }
                    if let datosSeguros = datos{
                        print("Datos Seguros")
                        print(datosSeguros)
                        let decodificador = JSONDecoder()
                        do{
                            let datosDecodificados = try decodificador.decode(MovieDatos.self, from: datosSeguros)
                            
                            print(datosDecodificados)
                            self.verInfo(datosDecodificados: datosDecodificados)
                        }catch{
                            print("Error en JSON: \(error.localizedDescription)")
                            
                        }
                    }
                }
                tarea.resume()
            }
        }
    }
    
    func verInfo(datosDecodificados: MovieDatos){
        DispatchQueue.main.async {
            self.tituloLbl.text = datosDecodificados.Title ?? ""
            self.lanzamientoLbl.text = "Año de lanzamiento: \(datosDecodificados.Released ?? "")"
            self.duracionLblb.text = "Duracion: \(datosDecodificados.Runtime ?? "")"
            self.generoLblb.text = datosDecodificados.Genre ?? ""
            self.paisLbl.text = "Pais: \(datosDecodificados.Country ?? "")"
        }
        if datosDecodificados.Poster != "N/A"{
            if let urlPoster = datosDecodificados.Poster{
                if let imagenURL = URL(string: urlPoster){
                    DispatchQueue.global().async {
                        guard let imagenData = try? Data(contentsOf: imagenURL) else {
                            return
                        }
                        let image = UIImage(data: imagenData)
                        DispatchQueue.main.async {
                            self.posterIV.image = image
                        }
                        
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.posterIV.image = UIImage(systemName: "film.fill")
            }
        }
        
    }
    @IBAction func guardarBtn(_ sender: UIButton) {
        if generoLblb.text != ""{
            let nuevoElemento = Pelicula(context: self.contexto)
            nuevoElemento.titulo = tituloLbl.text
            nuevoElemento.lanzamiento = lanzamientoLbl.text
            nuevoElemento.duracion = duracionLblb.text
            nuevoElemento.genero = generoLblb.text
            nuevoElemento.pais = paisLbl.text
            nuevoElemento.poster = posterIV.image?.pngData()
            
            do {
                try contexto.save()
                print("Datos guardados en coredata")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            //Regresar a la pantalla anterior
            navigationController?.popToRootViewController(animated: true)
        } else {
            print("Datos necesarios")
            
        }
    }
    
}
