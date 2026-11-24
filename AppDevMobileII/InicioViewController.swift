import UIKit

class InicioViewController: UIViewController {

    private let tituloLabel: UILabel = {
        let label = UILabel()
        label.text = "DevMobile II"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtituloLabel: UILabel = {
        let label = UILabel()
        label.text = "Aplicación iOS en Swift"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let comenzarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Comenzar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor(red: 0.20, green: 0.70, blue: 0.95, alpha: 1.0)
        button.accessibilityIdentifier = "btnComenzar"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Inicio"
        configurarInterfaz()
        comenzarButton.round()
        comenzarButton.addTarget(self, action: #selector(comenzarTapped(_:)), for: .touchUpInside)
    }

    private func configurarInterfaz() {
        view.addSubview(tituloLabel)
        view.addSubview(subtituloLabel)
        view.addSubview(comenzarButton)

        NSLayoutConstraint.activate([
            tituloLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tituloLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            tituloLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            subtituloLabel.topAnchor.constraint(equalTo: tituloLabel.bottomAnchor, constant: 12),
            subtituloLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            subtituloLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            comenzarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            comenzarButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            comenzarButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            comenzarButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            comenzarButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func comenzarTapped(_ sender: UIButton) {
        sender.bounce()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) { [weak self] in
            guard let self = self,
                  let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                return
            }
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
}
