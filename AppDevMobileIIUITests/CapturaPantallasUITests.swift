import XCTest

final class CapturaPantallasUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
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
        let btnComenzar = app.buttons["btnComenzar"]
        XCTAssertTrue(btnComenzar.waitForExistence(timeout: 10))
        sleep(1)
        guardarCaptura(nombre: "01_Inicio")

        // Navegar a Login
        btnComenzar.tap()

        // 2. Pantalla Login
        let txtUsuario = app.textFields["txtUsuario"]
        XCTAssertTrue(txtUsuario.waitForExistence(timeout: 10))
        txtUsuario.tap()
        txtUsuario.typeText("jhosep2026")

        let txtContrasena = app.secureTextFields["txtContrasena"]
        txtContrasena.tap()
        txtContrasena.typeText("123456\n")
        sleep(1)
        guardarCaptura(nombre: "02_Login")

        // Ingresar a Tareas
        let btnIngresar = app.buttons["btnIngresar"]
        XCTAssertTrue(btnIngresar.waitForExistence(timeout: 5))
        btnIngresar.tap()

        // 3. Pantalla Tareas (Core Data)
        let btnAgregar = app.navigationBars.buttons["btnAgregarTarea"]
        XCTAssertTrue(btnAgregar.waitForExistence(timeout: 10))

        // Agregar primera tarea
        btnAgregar.tap()
        let alertField1 = app.alerts["Nueva Tarea"].textFields.firstMatch
        XCTAssertTrue(alertField1.waitForExistence(timeout: 5))
        alertField1.typeText("Entregar examen iOS")
        app.alerts["Nueva Tarea"].buttons["Guardar"].tap()

        // Agregar segunda tarea
        sleep(1)
        btnAgregar.tap()
        let alertField2 = app.alerts["Nueva Tarea"].textFields.firstMatch
        XCTAssertTrue(alertField2.waitForExistence(timeout: 5))
        alertField2.typeText("Probar Core Data y WKWebView")
        app.alerts["Nueva Tarea"].buttons["Guardar"].tap()

        sleep(1)
        guardarCaptura(nombre: "03_Tareas")

        // 4. Pantalla Navegador (WKWebView + Alerta Resumen)
        let btnNavegador = app.navigationBars.buttons["btnIrANavegador"]
        XCTAssertTrue(btnNavegador.waitForExistence(timeout: 5))
        btnNavegador.tap()

        // Esperar a que cargue la web y aparezca la alerta de resumen
        sleep(5)
        guardarCaptura(nombre: "04_Navegador_Resumen")

        if app.alerts["Resumen de la App"].exists {
            app.alerts["Resumen de la App"].buttons["Aceptar"].tap()
            sleep(2)
            guardarCaptura(nombre: "05_Navegador_Web")
        }
    }
}
