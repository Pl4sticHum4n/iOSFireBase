//
//  RegistroViewController.swift
//  FireBase
//
//  Created by mac16 on 24/05/22.
//

import UIKit
import FirebaseAuth

class RegistroViewController: UIViewController {

    @IBOutlet weak var correoUser: UITextField!
    @IBOutlet weak var passUser: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registrarBtn(_ sender: UIButton) {
        if let email = correoUser.text, let password = passUser.text{
            Auth.auth().createUser(withEmail: email, password: password) { (resultado, error) in
                //Validar si hubo error
                if let e = error{
                    print("Error al crear usuario en Firebase: \(e.localizedDescription)")
                } else {
                    print("Usuario creado")
                    self.performSegue(withIdentifier: "registerMenu", sender: self
                    )
                }
            }
        }
        
        
    }
    
}
