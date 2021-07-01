//
//  RegisterViewController.swift
//  OnBoarding
//
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Registro de Usuario
    @IBAction func Registro(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text, let userName = nameTextField.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error == nil {
                    print("User created!")
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = userName
                    changeRequest?.commitChanges { error in
                    }
                    
                    // Almacenar los datos del usuario logueado para el UserDefaults
                    if let email = Auth.auth().currentUser?.email {
                        let defaults = UserDefaults.standard
                        defaults.set(email, forKey: "email")
                        defaults.synchronize()
                    }
                }
                if let e = error {
                    self.alertaMensaje(mjs: e.localizedDescription)
                } else {
                    // Navegar al siguiente ViewController
                    let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let sceneDelegate = windowScene.delegate as? SceneDelegate,
                        let window = sceneDelegate.window{
                        window.rootViewController = mainAppViewController
                        UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
                    }
                }
            }
        }
    }
    
    // MARK: - Mensajes en caso de Errores
    func alertaMensaje(mjs: String){
        switch mjs {
        case "The password must be 6 characters long or more.":
            let alert = UIAlertController(title: "Error", message: "La contraseña debe tener 6 caracteres o más.", preferredStyle: .alert)
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(actionAcept)
            self.present(alert, animated: true, completion: nil)
        case "The email address is badly formatted.":
            let alert = UIAlertController(title: "Error", message: "La dirección de correo electrónico está mal formateada.", preferredStyle: .alert)
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(actionAcept)
            self.present(alert, animated: true, completion: nil)
        case "The email address is already in use by another account.":
            let alert = UIAlertController(title: "Error", message: "La dirección de correo electrónico ya está siendo utilizada por otra cuenta.", preferredStyle: .alert)
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(actionAcept)
            self.present(alert, animated: true, completion: nil)
        default:
            print("Registro con exito")
        }
    }
}
