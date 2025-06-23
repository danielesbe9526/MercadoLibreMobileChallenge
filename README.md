# MercadoLibre Challenge en SwiftUI

## Descripción
Esta aplicación en **SwiftUI** presenta un marketplace con navegación **controlada**, gestión **dinámica de temas**, carga eficiente de imágenes, y componentes visuales personalizados. Incluye vistas de **detalle de producto**, **mode lista y cuadrícula**, **búsqueda avanzada**, **overlay**, **selector de color**, y **favoritos**. Además, soporta **cambios en temas en vivo** para una experiencia interactiva.

## Características principales
- **Listado y detalles de productos**:
  - **Modo lista** (`CardVView`) y **modo cuadrícula** (`CardHView`).
  - Pantalla de **detalle** (`ProductDetailView`) con galería de imágenes, **precios**, **calificaciones** (`StartsView`), **envío**, **stock**, y botones de compra.
- **Favoritos**:
  - Botón de **corazón** (`heartButton`) para marcar productos favoritos en detalles.
- **Temas y estilos**:
  - `ThemeManager` permite cambiar **temas en vivo** (claro, oscuro, personalizado) en `DeveloperView`.
  - `TextStyle` y `TextStyles` para **estilizar textos** de forma coherente.
- **Navegación**:
  - Controlada por `DestinationViewModel` y `ScreenDestination`.
  - **Navegación en pila** programática y control total del stack.
- **Ubicación en tiempo real**:
  - `LocationManager` obtiene y muestra **ubicación** y **dirección** del usuario.
- **Carga eficiente de imágenes**:
  - `CachedAsyncImage` para cargar y cachear imágenes remotas.
  - Galería en carrusel (`TabView`) con **paginación**.
- **Interfaz enriquecida**:
  - `ViewWrapper` gestiona **encabezado**, **búsqueda**, **overlay**, **selector de color**, **spinner**, y **alertas**.
  - **Overlay** de búsqueda con lista de items y **transiciones suaves**.
  - **Selector de color** para temas personalizados.
  - **Alertas** con botones y **animaciones**.

## Tecnologías utilizadas
- **SwiftUI**
- **CoreLocation**
- **Codable**
- **Async/await**

## Estructura del código
- **Vistas principales**:
  - `HomeView`: inicio con modo lista y cuadrícula.
  - `ProductDetailView`: detalles con galería, precios, calificaciones, envío, y favoritos.
  - `CardVView` y `CardHView`: tarjetas en modo lista y cuadrícula.
  - `ViewWrapper`: interfaz principal con búsqueda, overlay, spinner, alertas y temas.
  - `DeveloperView`: configuración en vivo de temas y colores.
- **Gestores**:
  - `LocationManager`: permisos y ubicación.
  - `ThemeManager`: gestión de temas.
  - `DestinationViewModel`: control de navegación.
  - `APIInteractor`: carga datos locales y remotos.
- **Modelos de datos**:
  - `Product`, `ProductDetail`, `Installments`.
- **Componentes visuales**:
  - `Alert`, `AlertModel`: alertas personalizadas.
  - `TextStyle`, `TextStyles`: estilos de textos.
  - `CachedAsyncImage`: carga y cachea imágenes remotas.
  - `PriceView`: visualización de precios.
  - `StartsView`: calificación con estrellas.

## Cómo empezar
1. Clona el repositorio:
ash
git clone 


 Copy code

2. Abre en Xcode:
ash
cd 
open .xcodeproj


 Copy code

3. Ejecuta en un simulador o dispositivo físico.

## Uso
- `HomeView` presenta productos en modo lista o cuadrícula, con transiciones suaves y filtros.
- La búsqueda en la cabecera permite filtrar productos, mostrando overlay con lista de items.
- La ubicación se muestra y actualiza automáticamente.
- La interfaz visual puede ser personalizada en vivo usando `ThemeManager`.
- En `ProductDetailView`, explora galería de imágenes, precios, calificaciones (`StartsView`), envío, stock, y favoritos con botón de corazón (`heartButton`).
- En `DeveloperView`, puedes personalizar los temas en vivo mediante selectores y `ColorPicker`.

## Componentes destacados
- **Temas de color**: Gestión dinámica entre temas claros, oscuros y personalizados.
- **Alertas personalizadas**: Animadas con botones y mensajes.
- **Estilos de texto**: Coherentes en toda la interfaz.
- **Navegación programática**: Control del stack en toda la app.
- **Interfaz enriquecida**:
  - Encabezado con búsqueda, ubicación y botones.
  - Overlay de búsqueda con lista y transiciones.
  - Galería de imágenes con carrusel y paginación (`TabView`).
  - Pantalla de configuración de temas (`DeveloperView`).
  - Favoritos en detalles con botón de corazón (`heartButton`).
