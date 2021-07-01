//
//  LoginViewController.swift
//  OnBoarding
//
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextFiled: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Iniciar Sesion
    @IBAction func login(_ sender: UIButton) {
        if let email = emailTextFiled.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.alertaMensaje(mjs: e.localizedDescription)
                } else {
                    // Almacenar los datos del usuario logueado para el UserDefaults
                    if let email = Auth.auth().currentUser?.email {
                        let defaults = UserDefaults.standard
                        defaults.set(email, forKey: "email")
                        defaults.synchronize()
                    }
                    
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
        case "The password is invalid or the user does not have a password.":
            let alert = UIAlertController(title: "Error", message: "La contraseña no es válida o el usuario no tiene contraseña.", preferredStyle: .alert)
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(actionAcept)
            self.present(alert, animated: true, completion: nil)
        case "The email address is badly formatted.":
            let alert = UIAlertController(title: "Error", message: "La dirección de correo electrónico está mal formateada.", preferredStyle: .alert)
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(actionAcept)
            self.present(alert, animated: true, completion: nil)
        case "There is no user record corresponding to this identifier. The user may have been deleted.":
            let alert = UIAlertController(title: "Error", message: "No hay ningún registro de usuario que corresponda a este correo. Es posible que el usuario haya sido eliminado.", preferredStyle: .alert)
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(actionAcept)
            self.present(alert, animated: true, completion: nil)
        default:
            print("Login con exito")
        }
    }
}
