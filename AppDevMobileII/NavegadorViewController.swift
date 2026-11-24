import UIKit
import WebKit
import CoreData

class NavegadorViewController: UIViewController, WKNavigationDelegate, UISearchBarDelegate {

    private var webView: WKWebView!
    private let searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()
    private var backButton: UIBarButtonItem!
    private var forwardButton: UIBarButtonItem!
    private var mostroResumen = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configurarWebView()
        configurarSearchBar()
        configurarToolbar()
        cargarURL("https://www.apple.com")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setToolbarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !mostroResumen {
            mostroResumen = true
            mostrarResumen()
        }
    }

    private func configurarWebView() {
        let configuracion = WKWebViewConfiguration()
        configuracion.defaultWebpagePreferences.allowsContentJavaScript = true

        webView = WKWebView(frame: .zero, configuration: configuracion)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false

        refreshControl.addTarget(self, action: #selector(recargarPagina), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func configurarSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "https://www.apple.com"
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.keyboardType = .URL
        navigationItem.titleView = searchBar
    }

    private func configurarToolbar() {
        backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(irAtras)
        )
        backButton.isEnabled = false

        forwardButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.forward"),
            style: .plain,
            target: self,
            action: #selector(irAdelante)
        )
        forwardButton.isEnabled = false

        let resumenButton = UIBarButtonItem(
            title: "Resumen",
            style: .plain,
            target: self,
            action: #selector(mostrarResumen)
        )

        let espacio = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarItems = [backButton, espacio, forwardButton, espacio, resumenButton]
    }

    private func cargarURL(_ texto: String) {
        var cadena = texto.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cadena.isEmpty else { return }

        if cadena.lowercased().hasPrefix("http://") {
            mostrarAlerta(titulo: "Dirección no permitida", mensaje: "Solo se permiten direcciones seguras con https://.")
            return
        }

        if !cadena.lowercased().hasPrefix("https://") {
            cadena = "https://" + cadena
        }

        guard let url = URL(string: cadena),
              url.scheme?.lowercased() == "https",
              url.host != nil else {
            mostrarAlerta(titulo: "URL inválida", mensaje: "Ingresa una dirección https válida.")
            return
        }

        searchBar.text = url.absoluteString
        webView.load(URLRequest(url: url))
    }

    @objc private func recargarPagina() {
        webView.reload()
    }

    @objc private func irAtras() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    @objc private func irAdelante() {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    @objc private func mostrarResumen() {
        let usuario = UserDefaults.standard.string(forKey: "kUsuario") ?? "Sin usuario"
        let cantidadTareas = obtenerCantidadTareas()
        let mensaje = "Usuario guardado: \(usuario)\nCantidad de tareas: \(cantidadTareas)"
        mostrarAlerta(titulo: "Resumen de la App", mensaje: mensaje)
    }

    private func obtenerCantidadTareas() -> Int {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return 0 }
        let contexto = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tarea")
        do {
            return try contexto.count(for: fetchRequest)
        } catch {
            return 0
        }
    }

    private func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default))
        present(alerta, animated: true)
    }

    // MARK: - UISearchBarDelegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let texto = searchBar.text else { return }
        cargarURL(texto)
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
        refreshControl.endRefreshing()
        if let actual = webView.url?.absoluteString {
            searchBar.text = actual
        }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        refreshControl.endRefreshing()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        refreshControl.endRefreshing()
    }
}
