//
//  ViewController.swift
//  FireBase
//
//  Created by mac16 on 23/05/22.
//

import UIKit
import CLTypingLabel
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var contraseñaUsuario: UITextField!
    @IBOutlet weak var correoUsuario: UITextField!
    @IBOutlet weak var mensajeBienvenida: CLTypingLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mensajeBienvenida.charInterval = 0.9
        mensajeBienvenida.text = "Inicia sesion"
        mensajeBienvenida.onTypingAnimationFinished = {
            self.mensajeBienvenida.textColor = .cyan
        }
        // MARK: - Valida si esta la sesion guardada
                
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String{
        //utilizar segue para ir al HOME VC
        print(email)
        print("Se encontro la sesion guardada y se navega a HOME VC")
            performSegue(withIdentifier: "loginMenu", sender: self)
        }
    }

    @IBAction func loginBtn(_ sender: UIButton) {
        if let email = correoUsuario.text, let password = contraseñaUsuario.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print("Error al iniciar sesion: \(e.localizedDescription)")
                } else {
                    print("Sesion Iniciada")
                    self!.performSegue(withIdentifier: "loginMenu", sender: self)
                }
            }
        }
        
    }
    
}

