//
//  ViewController.swift
//  OnBoarding
//
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Comprobacion de la sesion de usuario
        let defaults = UserDefaults.standard
        if let email = defaults.value(forKey: "email") as? String {
            print(email)
            // Utilizar un segue de inicio hasta el Chat
            let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate,
                let window = sceneDelegate.window{
                window.rootViewController = mainAppViewController
                UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
    
    // MARK: Visualizacion de OnBoardin o Vista Welcome
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if Core.shared.isNewUser(){
            Core.shared.notNewUser()
            // Aquí puede mostrar el guión gráfico que debe lanzar en el primer lanzamiento
            let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingVC")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate,
                let window = sceneDelegate.window{
                window.rootViewController = mainAppViewController
                UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        } else{
            // Aquí puede mostrar el guión gráfico que debe iniciar después del primer lanzamiento
            let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate,
                let window = sceneDelegate.window{
                window.rootViewController = mainAppViewController
                UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        }
    }
}

class Core{
    static let shared = Core()
    
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func notNewUser(){
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
}
