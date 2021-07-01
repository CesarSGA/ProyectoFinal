//
//  ProfileViewController.swift
//  OnBoarding
//
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Volver redondo el ImageView
        self.imageUser.layer.masksToBounds = true
        self.imageUser.layer.cornerRadius = self.imageUser.bounds.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.createSpinnerView()
        self.loadDataUser()
    }
    
//    @objc private func didTapChangeProfilePic(){
//        presentPhotoActionSheet()
//    }

    func createSpinnerView() {
        let child = SpinnerViewController()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)

        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    
    func loadDataUser(){
        let user = Auth.auth().currentUser
        if let user = user {
            let email = user.email
            let name = user.displayName
            self.mailTextField.placeholder = email
            self.nameTextField.placeholder = name
        }
    }
    
    @IBAction func changeImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func updateInfoButton(_ sender: UIButton) {
        if nameTextField.text != "" {
            // Variables para almacenar el contacto
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = nameTextField.text
                changeRequest.commitChanges { error in
                    if let error = error {
                      // An error happened.
                        print("Error: \(error.localizedDescription)")
                    } else {
                      // Profile updated.
                        print("Actualizacion Correcta")
                        self.viewWillAppear(true)
                        self.nameTextField.text = ""
                    }
                }
            }
        }
        
        if mailTextField.text != "" {
            let email = mailTextField.text
            Auth.auth().currentUser?.updateEmail(to: email!) { (error) in
                if let error = error {
                    // An error happened.
                    print("Error: \(error.localizedDescription)")
                } else {
                    // Profile updated.
                    print("Actualizacion Correcta")
                    self.viewWillAppear(true)
                    self.mailTextField.text = ""
                }
            }
        }
    }
    
    // MARK: - Cerrar Sesion
    @IBAction func logout(_ sender: UIBarButtonItem) {
        // Cerrar sesion con Google
        GIDSignIn.sharedInstance().signOut()
        
        // Eliminar los datos de la sesion
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "email")
        defaults.synchronize()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let mainAppViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeVC")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate,
                let window = sceneDelegate.window{
                window.rootViewController = mainAppViewController
                UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
            }
        } catch let error as NSError {
            let alert = UIAlertController(title: "Error", message: "No se pudo cerrar la sesion, por favor intente mas tarde.", preferredStyle: .alert)
            let actionAcept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alert.addAction(actionAcept)
            self.present(alert, animated: true, completion: nil)
            print("Error al cerrar sesion: \(error.localizedDescription)")
        }
    }
}

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}

// MARK: Metodos PickerController
extension ProfileViewController: UIImagePickerControllerDelegate {
    // MARK: Metodos de los delegados para el PickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagen = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage
        imageUser.image = imagen
        picker.dismiss(animated: true, completion: nil)
    }
}

//extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func presentPhotoActionSheet(){
//        let actionSheer = UIAlertController(title: "Foto de Perfil", message: "Selecciona tu foto", preferredStyle: .actionSheet)
//
//        actionSheer.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
//        actionSheer.addAction(UIAlertAction(title: "Tomar Foto", style: .default, handler: {[weak self] _ in self?.presentCamera()}))
//        actionSheer.addAction(UIAlertAction(title: "Galeria", style: .default, handler: {[weak self] _ in self?.presentPhotoPicker()}))
//        present(actionSheer, animated: true)
//    }
//
//    func presentCamera() {
//        let vc = UIImagePickerController()
//        vc.sourceType = .camera
//        vc.delegate = self
//        vc.allowsEditing = true
//        present(vc, animated: true)
//    }
//
//    func presentPhotoPicker() {
//        let vc = UIImagePickerController()
//        vc.sourceType = .photoLibrary
//        vc.delegate = self
//        vc.allowsEditing = true
//        present(vc, animated: true)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
//            return
//        }
//        self.imageUser.image = selectedImage
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//}


