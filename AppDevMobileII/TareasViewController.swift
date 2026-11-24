import UIKit
import CoreData

class TareasViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var tareas: [NSManagedObject] = []

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "TareaCell")
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Tareas"
        configurarInterfaz()
        configurarBarraNavegacion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarTareas()
    }

    private func configurarInterfaz() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func configurarBarraNavegacion() {
        let agregarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(agregarTareaTapped))
        agregarButton.accessibilityIdentifier = "btnAgregarTarea"

        let navegadorButton = UIBarButtonItem(title: "Navegador", style: .plain, target: self, action: #selector(irANavegadorTapped))
        navegadorButton.accessibilityIdentifier = "btnIrANavegador"

        navigationItem.rightBarButtonItems = [agregarButton, navegadorButton]
    }

    private func cargarTareas() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let contexto = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tarea")

        do {
            tareas = try contexto.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error al recuperar tareas: \(error.localizedDescription)")
        }
    }

    private func guardarTarea(nombre: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let contexto = appDelegate.persistentContainer.viewContext

        guard let entidad = NSEntityDescription.entity(forEntityName: "Tarea", in: contexto) else { return }
        let nuevaTarea = NSManagedObject(entity: entidad, insertInto: contexto)
        nuevaTarea.setValue(nombre, forKey: "nombre")

        do {
            try contexto.save()
            tareas.append(nuevaTarea)
            tableView.reloadData()
        } catch {
            print("Error al guardar tarea: \(error.localizedDescription)")
        }
    }

    @objc private func agregarTareaTapped() {
        let alerta = UIAlertController(title: "Nueva Tarea", message: "Escribe el nombre de la tarea", preferredStyle: .alert)
        alerta.addTextField { textField in
            textField.placeholder = "Nombre de la tarea"
            textField.accessibilityIdentifier = "txtNombreTarea"
        }

        let guardarAction = UIAlertAction(title: "Guardar", style: .default) { [weak self] _ in
            guard let texto = alerta.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !texto.isEmpty else {
                return
            }
            self?.guardarTarea(nombre: texto)
        }

        alerta.addAction(guardarAction)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alerta, animated: true)
    }

    @objc private func irANavegadorTapped() {
        guard let navegadorVC = storyboard?.instantiateViewController(withIdentifier: "NavegadorViewController") as? NavegadorViewController else {
            return
        }
        navigationController?.pushViewController(navegadorVC, animated: true)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tareas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TareaCell", for: indexPath)
        let tarea = tareas[indexPath.row]
        cell.textLabel?.text = tarea.value(forKey: "nombre") as? String ?? ""
        return cell
    }
}
