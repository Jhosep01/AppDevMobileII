import XCTest

final class CapturaPantallasUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = true
    }

    private func guardarCaptura(nombre: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = nombre
        attachment.lifetime = .keepAlways
        add(attachment)
    }

    func testFlujoCompletoYCapturas() throws {
        let app = XCUIApplication()
        app.launch()

        // 1. Pantalla Inicio
        let btnComenzar = app.buttons["btnComenzar"].firstMatch
        XCTAssertTrue(btnComenzar.waitForExistence(timeout: 30), "No aparecio btnComenzar")
        sleep(1)
        guardarCaptura(nombre: "01_Inicio")

        // Navegar a Login
        btnComenzar.tap()

        // 2. Pantalla Login
        let txtUsuario = app.textFields["txtUsuario"].firstMatch
        XCTAssertTrue(txtUsuario.waitForExistence(timeout: 20), "No aparecio txtUsuario")
        txtUsuario.tap()
        txtUsuario.typeText("jhosep2026")

        let txtContrasena = app.secureTextFields["txtContrasena"].firstMatch
        XCTAssertTrue(txtContrasena.waitForExistence(timeout: 10), "No aparecio txtContrasena")
        txtContrasena.tap()
        txtContrasena.typeText("123456\n")
        sleep(1)
        guardarCaptura(nombre: "02_Login")

        // Ingresar a Tareas
        let btnIngresar = app.buttons["btnIngresar"].firstMatch
        XCTAssertTrue(btnIngresar.waitForExistence(timeout: 10), "No aparecio btnIngresar")
        btnIngresar.tap()

        // 3. Pantalla Tareas (Core Data)
        let btnAgregar = app.navigationBars.buttons["btnAgregarTarea"].firstMatch
        XCTAssertTrue(btnAgregar.waitForExistence(timeout: 20), "No aparecio btnAgregarTarea")

        // Agregar primera tarea
        btnAgregar.tap()
        let alerta1 = app.alerts["Nueva Tarea"]
        XCTAssertTrue(alerta1.waitForExistence(timeout: 10), "No aparecio alerta 1")
        let alertField1 = alerta1.textFields.firstMatch
        alertField1.tap()
        alertField1.typeText("Entregar examen iOS")
        alerta1.buttons["Guardar"].tap()

        // Agregar segunda tarea
        sleep(1)
        btnAgregar.tap()
        let alerta2 = app.alerts["Nueva Tarea"]
        XCTAssertTrue(alerta2.waitForExistence(timeout: 10), "No aparecio alerta 2")
        let alertField2 = alerta2.textFields.firstMatch
        alertField2.tap()
        alertField2.typeText("Probar Core Data y WKWebView")
        alerta2.buttons["Guardar"].tap()

        sleep(1)
        guardarCaptura(nombre: "03_Tareas")

        // 4. Pantalla Navegador (WKWebView + Alerta Resumen)
        let btnNavegador = app.navigationBars.buttons["btnIrANavegador"].firstMatch
        XCTAssertTrue(btnNavegador.waitForExistence(timeout: 10), "No aparecio btnIrANavegador")
        btnNavegador.tap()

        // Esperar alerta de resumen y carga web
        let alertaResumen = app.alerts["Resumen de la App"]
        _ = alertaResumen.waitForExistence(timeout: 15)
        sleep(3)
        guardarCaptura(nombre: "04_Navegador_Resumen")

        if alertaResumen.exists {
            alertaResumen.buttons["Aceptar"].tap()
            sleep(3)
            guardarCaptura(nombre: "05_Navegador_Web")
        }
    }
}
