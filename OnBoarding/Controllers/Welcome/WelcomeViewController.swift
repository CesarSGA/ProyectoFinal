//
//  WelcomeViewController.swift
//  OnBoarding
//
//

import UIKit
import Firebase
import GoogleSignIn

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Delegados de GoogleSingIn
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    // MARK: - Registro con sesion de Google
    @IBAction func registerGoogleServices(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
}

// MARK: - Configuracion de Servicios de Sesion con Google
extension WelcomeViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // Si no hubo error y se obtuvo un usuario entonces
        if error == nil && user.authentication != nil {
            // Generar credencial con el token del usuario autenticado
            let credencial = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
            // Iniciar sesion en Firebase con una credencial de Google
            Auth.auth().signIn(with: credencial) { (authResult, error) in
                // Si se obtuvo respuesta al iniciar sesion y no hubo error
                if let result = authResult, error == nil {
                    // Almacenar los datos del usuario logueado para el UserDefaults
                    if let email = Auth.auth().currentUser?.email {
                        let defaults = UserDefaults.standard
                        defaults.set(email, forKey: "email")
                        defaults.synchronize()
                    }
                    // Navegacion de vista inicial a la vista
                    let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let sceneDelegate = windowScene.delegate as? SceneDelegate,
                        let window = sceneDelegate.window{
                        window.rootViewController = mainAppViewController
                        UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
                    }
                    print(result)
                } else {
                    let alert = UIAlertController(title: "Error", message: "No pudimos registrate a traves de tu sesion con Google.", preferredStyle: .alert)
                    let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                    alert.addAction(actionAcept)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
