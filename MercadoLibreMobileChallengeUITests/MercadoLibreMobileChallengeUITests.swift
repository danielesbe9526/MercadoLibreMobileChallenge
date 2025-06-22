//
//  MercadoLibreMobileChallengeUITests.swift
//  MercadoLibreMobileChallengeUITests
//
//  Created by Daniel Beltran on 21/06/25.
//

import XCTest

final class MercadoLibreMobileChallengeUITests: XCTestCase {

    override func setUpWithError() throws {
         // Configuración inicial antes de cada prueba.
         continueAfterFailure = false
         XCUIApplication().launch()
     }

     override func tearDownWithError() throws {
         // Limpieza después de cada prueba.
     }

     func testProducDetail() throws {
         let app = XCUIApplication()
         let _ = app.waitForExistence(timeout: 3)
         
         XCTAssertTrue(app.staticTexts["RAYNOR LLC"].exists)
         XCTAssertTrue(app.staticTexts["MOTOROLA"].exists)
         
         app.staticTexts["MOTOROLA"].firstMatch.tap()
         
         let _ = app.waitForExistence(timeout: 1)

         XCTAssertTrue(app.staticTexts["Incredible Bronze Soap - Distribuidor Autorizado"].exists)
         XCTAssertTrue(app.staticTexts["Nuevo | +100 vendidos"].exists)
         
         
         XCTAssertTrue(app.staticTexts["$1.410.331"].exists)
         XCTAssertTrue(app.staticTexts["Nuevo | +100 vendidos"].exists)

         XCTAssertTrue(app.staticTexts["o mismo precio en 3639149146068879 cuotas sin tarjeta"].exists)
         XCTAssertTrue(app.staticTexts["Ver los medios de pago"].exists)

         let scrollView = app.scrollViews.firstMatch
         scrollView.swipeUp()
         
         XCTAssertTrue(app.staticTexts["Llega Mañana"].exists)
         XCTAssertTrue(app.staticTexts["Mas formas de entrega"].exists)
         XCTAssertTrue(app.staticTexts["Retira gratis a partir del sabado en correos y otros puntos"].exists)
         XCTAssertTrue(app.staticTexts["Tienes un punto de entrega a 450m"].exists)
         XCTAssertTrue(app.staticTexts["Ver en el mapa"].exists)
         
         if app.buttons["BackButton"].exists {
             let back = app.buttons["BackButton"]
             back.tap()
             _ = back.waitForExistence(timeout: 1.0)
         }
         
         XCTAssertTrue(app.staticTexts["RAYNOR LLC"].exists)
         XCTAssertTrue(app.staticTexts["MOTOROLA"].exists)
     }
    
    func testHeader() throws {
        let app = XCUIApplication()
        let _ = app.waitForExistence(timeout: 3)
        
        XCTAssertTrue(app.staticTexts["Buscar..."].exists)
        
        app.staticTexts["Buscar..."].firstMatch.tap()
        
        XCTAssertTrue(app.staticTexts["Buscar en Mercado Libre"].exists)
        XCTAssertTrue(app.staticTexts["iPhone"].exists)
        XCTAssertTrue(app.staticTexts["Samsung"].exists)
        XCTAssertTrue(app.staticTexts["Pelota"].exists)

        let _ = app.waitForExistence(timeout: 3)

        let back = app.buttons["BackListButton"]
        back.tap()
        
        XCTAssertTrue(app.staticTexts["MOTOROLA"].exists)
        
        let setUpButton = app.buttons["SetUpButton"]
        setUpButton.tap()
        
        XCTAssertTrue(app.staticTexts["RAYNOR LLC"].exists)
        XCTAssertTrue(app.staticTexts["MOTOROLA"].exists)
        
        let gridButton = app.buttons["GridButton"]
        gridButton.tap()
                
        XCTAssertFalse(app.staticTexts["RAYNOR LLC"].exists)
        
        let listButton = app.buttons["ListButton"]
        listButton.tap()
        
        XCTAssertTrue(app.staticTexts["RAYNOR LLC"].exists)
        XCTAssertTrue(app.staticTexts["MOTOROLA"].exists)
        
        let developerButton = app.buttons["DeveloperButton"]
        developerButton.tap()
        
        XCTAssertTrue(app.staticTexts["Configura tu app"].exists)
        XCTAssertTrue(app.staticTexts["Selecciona un tema"].exists)
        
        let _ = app.waitForExistence(timeout: 1)
    }
    
}
