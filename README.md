# 🛍️ Teslo App

Aplicación móvil de e-commerce construida con Flutter, implementando Clean Architecture, gestión de estado con Riverpod y funcionalidades CRUD completas para la administración de productos.

## 📱 Vista Previa de la Aplicación

<table>
  <tr>
    <th>Login</th>
    <th>Lista de Productos</th>
  </tr>
  <tr>
    <td><img src="assets/images/login.png" alt="Login" width="350" /></td>
    <td><img src="assets/images/lista-productos.png" alt="Lista de Productos" width="350" /></td>
  </tr>
  <tr>
    <th>Detalles de Producto</th>
    <th>Editar Producto</th>
  </tr>
  <tr>
    <td><img src="assets/images/detalles-productos.png" alt="Detalles de Producto" width="350" /></td>
    <td><img src="assets/images/editar-producto.png" alt="Editar Producto" width="350" /></td>
  </tr>
</table>

## 🧾 Tabla de Contenidos

- [Características](#-características)
- [Arquitectura](#-arquitectura)
- [Tecnologías](#-tecnologías)
- [Requisitos Previos](#-requisitos-previos)
- [Instalación](#-instalación)
- [Configuración](#-configuración)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Funcionalidades](#-funcionalidades)
- [Comandos Útiles](#️-comandos-útiles)
- [Guías de Desarrollo](#-guías-de-desarrollo)
- [Patrones Implementados](#-patrones-implementados)

## ✨ Características

### Autenticación y Seguridad

- 🔐 **Sistema completo de autenticación** (Login/Registro/Logout)
- 💽 **Persistencia de sesión** con SharedPreferences
- 🛡️ **Rutas protegidas** con redirección automática
- 🔑 **Tokens JWT** para autorización de API
- ✅ **Validación avanzada** de formularios

### Gestión de Productos

- 📦 **CRUD completo** de productos
- 📸 **Manejo de imágenes** (cámara y galería)
- 🔄 **Scroll infinito** con carga paginada
- 🔍 **Vista detallada** de productos con carrusel de imágenes
- ✏️ **Edición en tiempo real** con validación automática
- 🏷️ **Sistema de etiquetas (tags)** dinámico
- 📏 **Selector de tallas** interactivo
- 👔 **Categorización por género** (Hombre/Mujer/Niño/Unisex)

### Interfaz y UX

- 🎨 **Material Design 3** moderno
- 📱 **Diseño responsive** para múltiples dispositivos
- 🖼️ **Vista previa de imágenes** con zoom (InteractiveViewer)
- 📛 **Loading states** y manejo elegante de errores
- 🔔 **Notificaciones** con SnackBars
- ⚡ **Navegación fluida** sin recargas innecesarias
- 🎯 **Feedback visual** en todas las interacciones

### Características Técnicas

- 🏗️ **Clean Architecture** (Domain, Data, Presentation)
- 🔄 **State Management** con Riverpod
- 🌍 **HTTP Client** con Dio y manejo de errores
- 📂 **Patrón Adapter** para servicios de cámara/galería
- 🗃️ **Mappers** para transformación de datos
- 🪪 **Validaciones personalizadas** extensibles
- 🔌 **Inyección de dependencias** con Riverpod providers

## 🏛️ Arquitectura

El proyecto implementa **Clean Architecture** con la siguiente estructura de capas:

```
lib/
├── domain/          # Entidades y repositorios (contratos)
├── data/            # Implementaciones, datasources y mappers
└── presentation/    # UI, providers y widgets
```

### Capas

- **Domain**: Entidades del negocio y contratos de repositorios
- **Data**: Implementación de repositorios, fuentes de datos y mappers
- **Presentation**: Pantallas, widgets, providers y lógica de UI

## 🛠️ Tecnologías

### Dependencias principales

| Paquete | Versión | Propósito |
|---------|---------|-----------|
| `flutter_riverpod` | ^2.6.1 | Gestión de estado reactiva |
| `go_router` | ^16.0.0 | Navegación declarativa |
| `dio` | ^5.8.0+1 | Cliente HTTP con interceptores |
| `flutter_dotenv` | ^5.2.1 | Variables de entorno |
| `form_validator` | ^2.1.1 | Validación declarativa de formularios |
| `image_picker` | ^1.2.0 | Selección de imágenes (cámara/galería) |
| `shared_preferences` | ^2.5.3 | Persistencia local de datos |
| `intl` | ^0.20.2 | Internacionalización y formato |

## 📦 Requisitos Previos

- **Flutter SDK**: ^3.8.0
- **Dart SDK**: ^3.8.0
- **Backend API**: Servidor REST corriendo (ver configuración)
- **Editor**: VS Code o Android Studio recomendado

## 🚀 Instalación

### 1. Clonar el repositorio

```bash
git clone <repository-url>
cd teslo_app
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Verificar instalación

```bash
flutter doctor
```

## ⚙️ Configuración

### Variables de Entorno

1. **Crear archivo `.env`** en la raíz del proyecto:

```bash
# Windows (PowerShell)
New-Item .env

# macOS/Linux
touch .env
```

2. **Configurar la URL del API** (basado en `.env.example`):

```env
API_URL=http://localhost:3000/api
```

> **Nota**: Si usas un emulador de Android, reemplaza `localhost` con `10.0.2.2`. Para dispositivos físicos, usa la IP de tu computadora.

### Credenciales de prueba

Para probar la aplicación, puedes usar:

```
Email: test@test.com
Password: 123456
```

## 📁 Estructura del Proyecto

```
lib/
├── config/
│   ├── constants/       # Constantes globales (URLs, variables de entorno)
│   ├── router/          # Configuración de rutas (GoRouter + notificadores)
│   └── theme/           # Tema de la aplicación (colores, estilos)
├── core/
│   ├── camera_gallery/  # Servicio de cámara/galería (Adapter Pattern)
│   ├── storage/         # Almacenamiento local (SharedPreferences)
│   └── utils/           # Utilidades compartidas (validaciones personalizadas)
├── data/
│   ├── datasources/     # Fuentes de datos remotas (APIs con Dio)
│   ├── errors/          # Definición de errores personalizados
│   ├── mappers/         # Conversión entre DTOs y entidades
│   └── repositories/    # Implementación de repositorios
├── domain/
│   ├── datasources/     # Contratos de datasources
│   ├── entities/        # Entidades del dominio (Product, User, FileUploaded)
│   └── repositories/    # Contratos de repositorios
├── presentation/
│   ├── features/        # Pantallas organizadas por funcionalidad
│   │   ├── auth/        # Login, Register
│   │   │   ├── login/
│   │   │   │   └── screens/
│   │   │   └── register/
│   │   │       └── screens/
│   │   └── products/    # Productos (CRUD completo)
│   │       ├── screens/
│   │       │   ├── products_screen.dart              # Lista con scroll infinito
│   │       │   ├── product_detail_screen.dart        # Detalles con carrusel
│   │       │   └── create_update_product_screen.dart # Formulario CRUD
│   │       └── widgets/
│   │           ├── product_card.dart                 # Card de producto
│   │           ├── product_image_carousel.dart       # Carrusel de imágenes
│   │           └── product_image_selector.dart       # Selector de imágenes
│   ├── providers/       # Providers de Riverpod (estado global)
│   │   ├── auth_provider.dart
│   │   ├── products_provider.dart
│   │   ├── product_provider.dart
│   │   ├── product_form_provider.dart
│   │   └── product_repository_provider.dart
│   └── shared/          # Widgets y screens compartidos
│       ├── screens/
│       └── widgets/
└── main.dart            # Punto de entrada de la aplicación
```

## 🎯 Funcionalidades

### Autenticación 🔐

- ✅ **Inicio de sesión** con email/password
- ✅ **Registro de nuevos usuarios** con validación completa
- ✅ **Cierre de sesión** con limpieza de estado
- ✅ **Persistencia de sesión** automática con tokens JWT
- ✅ **Validación de formularios** en tiempo real
- ✅ **Manejo de errores** de autenticación con mensajes claros
- ✅ **Redirección automática** según estado de autenticación
- ✅ **Splash screen** durante verificación de sesión

### Productos 📦

#### Listado de Productos

- ✅ **Grid responsivo** de productos con imágenes
- ✅ **Scroll infinito** con carga paginada (lazy loading)
- ✅ **Estados de carga** con indicadores visuales
- ✅ **Botón flotante** para crear nuevo producto
- ✅ **Navegación** al detalle del producto
- ✅ **Refresh** manual de la lista

#### Detalles de Producto

- ✅ **Carrusel de imágenes** con indicadores de página
- ✅ **Información completa** del producto (título, precio, descripción)
- ✅ **Visualización de tallas** disponibles con chips
- ✅ **Tags/etiquetas** del producto
- ✅ **Información de stock** con estado visual
- ✅ **Botón de edición** en AppBar
- ✅ **Navegación fluida** con animaciones

#### Crear/Editar Producto ✏️

- ✅ **Formulario completo** con todos los campos del producto
- ✅ **Validación en tiempo real** mientras el usuario escribe
- ✅ **Validaciones personalizadas:**
  - Título (mínimo 3 caracteres)
  - Slug (formato URL-friendly, auto-generado desde título)
  - Precio (solo números positivos)
  - Stock (números desde 0)
  - Descripción (mínimo 10 caracteres)
- ✅ **Selector de género** con ChoiceChips (Hombre/Mujer/Niño/Unisex)
- ✅ **Selector de tallas** con FilterChips (XS, S, M, L, XL, XXL)
- ✅ **Sistema de tags** con adición y eliminación dinámica
- ✅ **Manejo de imágenes avanzado:**
  - 📷 Captura con cámara del dispositivo
  - 🖼️ Selección múltiple desde galería
  - 🔍 Vista previa ampliada con zoom (InteractiveViewer)
  - ❌ Eliminación individual de imágenes
  - 🏷️ Distinción visual entre imágenes remotas y locales
  - ☁️ Carga automática al servidor
  - 📊 Contador de imágenes
- ✅ **Auto-generación de slug** desde el título
- ✅ **Botón de refrescar slug** manualmente
- ✅ **Carga de datos** automática al editar
- ✅ **Actualización en tiempo real** tras guardar
- ✅ **Mensajes de éxito/error** con SnackBars
- ✅ **Loading state** durante operaciones asíncronas
- ✅ **Navegación automática** tras guardar exitosamente

### Estado y Navegación 🔄

- ✅ **Gestión de estado reactiva** con Riverpod
- ✅ **Providers especializados** por funcionalidad
- ✅ **Navegación declarativa** con GoRouter
- ✅ **Rutas protegidas** con guards de autenticación
- ✅ **Deep linking** preparado
- ✅ **Refresh de estado** selectivo y optimizado
- ✅ **Invalidación de cache** cuando es necesario

### Manejo de Imágenes 📸

- ✅ **Patrón Adapter** para servicios de cámara/galería
- ✅ **Permisos de Android** configurados automáticamente
- ✅ **Compresión de imágenes** al 80% de calidad
- ✅ **Upload asíncrono** con feedback visual
- ✅ **Diferenciación inteligente** entre URLs remotas y archivos locales
- ✅ **Grid de 3 columnas** responsive
- ✅ **Badge visual** para imágenes nuevas
- ✅ **Placeholder** cuando no hay imágenes
- ✅ **Manejo de errores** en carga de imágenes

## ⌨️ Comandos Útiles

### Desarrollo

```bash
# Ejecutar la aplicación
flutter run

# Ejecutar en un dispositivo específico
flutter run -d <device-id>

# Modo release
flutter run --release
```

### Análisis y Formato

```bash
# Analizar el código
flutter analyze

# Formatear el código
dart format .

# Aplicar correcciones automáticas
dart fix --apply
```

### Limpieza y Compilación

```bash
# Limpiar temporales
flutter clean

# Reinstalar dependencias
flutter pub get

# Actualizar dependencias
flutter pub upgrade
```

### Testing

```bash
# Ejecutar tests
flutter test

# Ejecutar tests con coverage
flutter test --coverage
```

## 🗺️ Guías de Desarrollo

### Configuración de Linter

Para usar **comillas simples** en lugar de dobles:

1. Editar `analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_single_quotes: true
```

2. Aplicar cambios:

```bash
flutter analyze
dart fix --apply
```

### Agregar nuevas dependencias

```bash
# Agregar dependencia
flutter pub add <package_name>

# Agregar dependencia de desarrollo
flutter pub add --dev <package_name>
```

### Gestión de Estado con Riverpod

```dart
// 1. Definir un provider
final myProvider = StateNotifierProvider<MyNotifier, MyState>((ref) {
  return MyNotifier();
});

// 2. Consumir en un ConsumerWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return Text(state.value);
  }
}

// 3. Modificar el estado
ref.read(myProvider.notifier).updateValue();

// 4. Invalidar cache para refrescar
ref.invalidate(productProvider(productId));
```

### Navegación con GoRouter

```dart
// Navegar a una ruta nombrada
context.goNamed('products');

// Navegar con parámetros de ruta
context.goNamed('product-detail', pathParameters: {'id': '123'});

// Navegar a editar producto
context.goNamed('product-edit', pathParameters: {'id': '123'});

// Volver atrás
context.pop();

// Reemplazar la ruta actual
context.go('/');
```

### Uso del Servicio de Cámara/Galería

```dart
// 1. Instanciar el servicio
final CameraGalleryService _cameraGalleryService = CameraGalleryServiceImpl();

// 2. Tomar foto con la cámara
final photoPath = await _cameraGalleryService.takePhoto();
if (photoPath != null) {
  // Usar la ruta del archivo
}

// 3. Seleccionar de la galería
final photoPath = await _cameraGalleryService.selectPhoto();

// 4. Seleccionar múltiples imágenes
final images = await _cameraGalleryService.selectMultiplePhotos();
```

### Validaciones Personalizadas

```dart
// Validador con extensiones personalizadas
final titleValidator = ValidationBuilder()
    .required()
    .minLength(3)
    .build();

final slugValidator = ValidationBuilder()
    .required()
    .isSlug()  // Extensión personalizada
    .build();

final priceValidator = ValidationBuilder()
    .required()
    .integer()
    .positive()  // Extensión personalizada
    .build();

// Usar en TextFormField
TextFormField(
  controller: _titleController,
  validator: titleValidator,
  autovalidateMode: AutovalidateMode.always, // Validación en tiempo real
)
```

## 🎨 Patrones Implementados

### Clean Architecture

```text
┌─────────────────────────────────────────────┐
│           Presentation Layer                │
│  (UI, Widgets, Screens, Providers)          │
│                                             │
│  • ConsumerWidget/ConsumerStatefulWidget    │
│  • Riverpod Providers (State Management)    │
│  • Navigation (GoRouter)                    │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│             Domain Layer                    │
│  (Business Logic, Entities, Contracts)      │
│                                             │
│  • Entities (Product, User, FileUploaded)   │
│  • Repository Interfaces                    │
│  • DataSource Interfaces                    │
└──────────────────┬──────────────────────────┘
                   │
                   ▼
┌─────────────────────────────────────────────┐
│              Data Layer                     │
│  (External Data, Implementations)           │
│                                             │
│  • DataSource Implementations (HTTP)        │
│  • Repository Implementations               │
│  • Mappers (DTO ↔ Entity)                   │
│  • External Services (Dio, SharedPrefs)     │
└─────────────────────────────────────────────┘
```

### Adapter Pattern

Usado para aislar la lógica de negocio de las dependencias externas (image_picker):

```dart
// Contrato (abstracción)
abstract class CameraGalleryService {
  Future<String?> takePhoto();
  Future<String?> selectPhoto();
  Future<List<String>> selectMultiplePhotos();
}

// Implementación concreta
class CameraGalleryServiceImpl implements CameraGalleryService {
  final ImagePicker _picker = ImagePicker();
  
  @override
  Future<String?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    return photo?.path;
  }
  // ... más métodos
}
```

**Ventajas:**

- ✅ Desacoplamiento de dependencias externas
- ✅ Fácil testing con mocks
- ✅ Cambio de implementación sin afectar la lógica de negocio
- ✅ Código más mantenible y escalable

### Repository Pattern

Separa la lógica de acceso a datos de la lógica de negocio:

```dart
// Domain (contrato)
abstract class ProductDataSource {
  Future<List<Product>> findAllProductsByPage({int limit, int offset});
  Future<Product> findProductById(String id);
  Future<Product> createProduct(Product product);
  Future<Product> updateProduct(Product product);
}

// Data (implementación)
class ProductRemoteDataSourceImpl extends ProductDataSource {
  final Dio apiClient;
  // Implementación con HTTP requests
}
```

### Provider Pattern (Riverpod)

Inyección de dependencias y gestión de estado:

```dart
// Provider de repositorio
final productRepositoryProvider = Provider<ProductDataSource>((ref) {
  final authState = ref.watch(authProvider);
  return ProductRemoteDataSourceImpl(accessToken: authState.token ?? '');
});

// StateNotifier para estado complejo
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return ProductsNotifier(productRepository: productRepository);
});
```

### Mapper Pattern

Transformación entre capas (DTOs ↔ Entities):

```dart
class ProductMapper {
  static Product productJsonToEntity(Map<String, dynamic> json) => Product(
    id: json['id'],
    title: json['title'],
    price: json['price'],
    // ... más campos con lógica de transformación
  );
  
  static Map<String, dynamic> productEntityToJson(Product product) => {
    'id': product.id,
    'title': product.title,
    // ... transformación inversa
  };
}
```

## 🔧 Solución de Problemas

### Error de conexión al backend

Si recibes `Connection refused` o `SocketException`:

1. Verifica que el backend esté ejecutándose
2. Comprueba la URL en `.env`
3. **Para Android emulator:** usa `10.0.2.2` en lugar de `localhost`
4. **Para dispositivo físico:** usa la IP de tu computadora en la red local (ej: `192.168.1.100`)
5. Verifica que el puerto sea el correcto (generalmente `3000`)

```env
# Emulador Android
API_URL=http://10.0.2.2:3000/api

# Dispositivo físico (reemplaza con tu IP)
API_URL=http://192.168.1.100:3000/api
```

### Error con variables de entorno

```bash
# Verificar que el archivo .env exista
ls .env  # Unix/Mac
dir .env # Windows

# Verificar que esté en pubspec.yaml
flutter:
  assets:
    - .env
```

### Error de permisos (cámara/galería) en Android

Si aparece `PlatformException` al usar la cámara:

1. Asegúrate de que los permisos estén en `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

2. Ejecuta `flutter clean` y recompila la app
3. En dispositivo físico, acepta los permisos cuando se soliciten

### Error de compilación tras agregar dependencias

```bash
# Limpiar y reinstalar
flutter clean
flutter pub get
flutter run
```

### Errores de lint

```bash
# Ver todos los errores
flutter analyze

# Aplicar correcciones automáticas
dart fix --apply
```

## ✅ Recursos Adicionales

### Documentación oficial

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Dio Documentation](https://pub.dev/packages/dio)

### Tutoriales relacionados

- [Clean Architecture en Flutter](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Riverpod Guide](https://codewithandrea.com/articles/flutter-state-management-riverpod/)
- [GoRouter Deep Dive](https://docs.flutter.dev/ui/navigation)

## 🤝 Contribución

Este es un proyecto educativo. Si encuentras bugs o tienes sugerencias:

1. Crea un issue describiendo el problema
2. Fork el proyecto
3. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
4. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
5. Push a la rama (`git push origin feature/AmazingFeature`)
6. Abre un Pull Request

## 📝 Notas de Desarrollo

### Consideraciones de seguridad

- ✅ Tokens JWT almacenados de forma segura con SharedPreferences
- ✅ Variables de entorno para datos sensibles (`.env`)
- ✅ Nunca commitear el archivo `.env` (incluido en `.gitignore`)
- ✅ Validación de inputs en cliente y servidor
- ✅ Manejo seguro de errores sin exponer información sensible

### Optimizaciones implementadas

- ✅ Lazy loading de productos (paginación)
- ✅ Caché de imágenes por defecto en Flutter
- ✅ Compresión de imágenes al 80% antes de subir
- ✅ Debouncing implícito en validaciones de formulario
- ✅ Invalidación selectiva de estado con Riverpod
- ✅ Widgets optimizados con `const` cuando es posible

### Próximas mejoras sugeridas

- 🔮 Búsqueda y filtrado de productos
- 🔮 Ordenamiento de productos (precio, nombre, fecha)
- 🔮 Carrito de compras
- 🔮 Sistema de favoritos
- 🔮 Perfil de usuario editable
- 🔮 Modo offline con sincronización
- 🔮 Notificaciones push
- 🔮 Testing unitario y de integración
- 🔮 CI/CD pipeline

## 📃 Licencia

Este proyecto es parte de un curso educativo de Flutter.

---

**Desarrollado con** ❤️ **usando Flutter** | **Clean Architecture** | **Riverpod**

**Versión:** 0.1.0 | **SDK:** ^3.8.0
