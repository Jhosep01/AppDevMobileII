import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    private let kUsuario = "kUsuario"

    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.text = "Iniciar Sesión"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let usuarioTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Usuario"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.returnKeyType = .next
        tf.accessibilityIdentifier = "txtUsuario"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let contrasenaTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Contraseña"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.returnKeyType = .done
        tf.accessibilityIdentifier = "txtContrasena"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let ingresarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ingresar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.backgroundColor = UIColor(red: 0.20, green: 0.70, blue: 0.95, alpha: 1.0)
        button.accessibilityIdentifier = "btnIngresar"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let cerrarSesionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cerrar sesión", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemRed
        button.accessibilityIdentifier = "btnCerrarSesion"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Login"
        configurarInterfaz()
        usuarioTextField.delegate = self
        contrasenaTextField.delegate = self
        ingresarButton.round()
        cerrarSesionButton.round()

        ingresarButton.addTarget(self, action: #selector(ingresarTapped(_:)), for: .touchUpInside)
        cerrarSesionButton.addTarget(self, action: #selector(cerrarSesionTapped(_:)), for: .touchUpInside)

        cargarUsuarioGuardado()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarUsuarioGuardado()
    }

    private func configurarInterfaz() {
        view.addSubview(tituloLabel)
        view.addSubview(usuarioTextField)
        view.addSubview(contrasenaTextField)
        view.addSubview(ingresarButton)
        view.addSubview(cerrarSesionButton)

        NSLayoutConstraint.activate([
            ingresarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ingresarButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ingresarButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            ingresarButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            ingresarButton.heightAnchor.constraint(equalToConstant: 48),

            contrasenaTextField.bottomAnchor.constraint(equalTo: ingresarButton.topAnchor, constant: -12),
            contrasenaTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            contrasenaTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            contrasenaTextField.heightAnchor.constraint(equalToConstant: 44),

            usuarioTextField.bottomAnchor.constraint(equalTo: contrasenaTextField.topAnchor, constant: -12),
            usuarioTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            usuarioTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            usuarioTextField.heightAnchor.constraint(equalToConstant: 44),

            tituloLabel.bottomAnchor.constraint(equalTo: usuarioTextField.topAnchor, constant: -12),
            tituloLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            tituloLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            cerrarSesionButton.topAnchor.constraint(equalTo: ingresarButton.bottomAnchor, constant: 12),
            cerrarSesionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            cerrarSesionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            cerrarSesionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func cargarUsuarioGuardado() {
        if let usuarioGuardado = UserDefaults.standard.string(forKey: kUsuario) {
            usuarioTextField.text = usuarioGuardado
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usuarioTextField {
            contrasenaTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    @objc private func ingresarTapped(_ sender: UIButton) {
        sender.bounce()
        view.endEditing(true)

        let usuario = (usuarioTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let contrasena = (contrasenaTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        if usuario.isEmpty || contrasena.isEmpty {
            mostrarAlerta(titulo: "Error al iniciar sesión", mensaje: "Debe completar los campos de usuario y contraseña.")
            return
        }

        if usuario.count <= 6 {
            mostrarAlerta(titulo: "Error al iniciar sesión", mensaje: "El usuario debe tener más de 6 caracteres.")
            return
        }

        if contrasena.count <= 3 {
            mostrarAlerta(titulo: "Error al iniciar sesión", mensaje: "La contraseña debe tener más de 3 caracteres.")
            return
        }

        UserDefaults.standard.set(usuario, forKey: kUsuario)

        guard let tareasVC = storyboard?.instantiateViewController(withIdentifier: "TareasViewController") as? TareasViewController else {
            return
        }
        navigationController?.pushViewController(tareasVC, animated: true)
    }

    @objc private func cerrarSesionTapped(_ sender: UIButton) {
        sender.bounce()
        UserDefaults.standard.removeObject(forKey: kUsuario)
        usuarioTextField.text = ""
        contrasenaTextField.text = ""
        mostrarAlerta(titulo: "Sesión cerrada", mensaje: "Se eliminó el usuario guardado.")
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }
}
