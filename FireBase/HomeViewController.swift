//
//  HomeViewController.swift
//  FireBase
//
//  Created by mac16 on 24/05/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var imagen: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Gif
        let gif = UIImage.gifImageWithName("giphy-7")
        imagen.image = gif
        
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        //una vez que el usuario se logueo guardamos la sesion
        if let email = Auth.auth().currentUser?.email {
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        //title = email
        print("Se guardó la sesion")
            defaults.synchronize()
        }
        
        
    }
    

    @IBAction func cerrarSesionBtn(_ sender: UIButton) {
        //Hay que eliminar la data de UserDefaults
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        print("Se eliminó la sesion")
        defaults.synchronize()
        
        do{
            try Auth.auth().signOut()
            print("Sesion cerrada")
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error al cerrar sesion:  \(error.localizedDescription)")
        }
    }
    
    

}
