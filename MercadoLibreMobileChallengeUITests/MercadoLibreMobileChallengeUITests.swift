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

     func testHomeViewDisplaysProducts() throws {
         let app = XCUIApplication()
         
         // Verifica que la vista principal se cargue correctamente.
         XCTAssertTrue(app.scrollViews["HomeScrollView"].exists)
         
         // Verifica que los productos se muestren en la lista.
         let firstCell = app.scrollViews["HomeScrollView"].cells.element(boundBy: 0)
         XCTAssertTrue(firstCell.exists)
         
         // Toca el primer producto y verifica que se navegue al detalle.
         firstCell.tap()
         XCTAssertTrue(app.otherElements["ProductDetailView"].exists)
     }
}
