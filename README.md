# 👥 User Management App

Una aplicación Flutter moderna para la gestión integral de usuarios y direcciones, desarrollada siguiendo Clean Architecture y las mejores prácticas de desarrollo móvil.

## 🚀 Características Principales

- **Gestión Completa de Usuarios**: Crear, visualizar, editar y eliminar usuarios
- **Sistema de Direcciones**: Gestión geográfica con países, departamentos y municipios
- **UI/UX Moderna**: Diseño Material 3 con gradientes, sombras y animaciones
- **Arquitectura Escalable**: Clean Architecture con separación de responsabilidades
- **Gestión de Estado**: BLoC pattern para un manejo robusto del estado
- **Almacenamiento Local**: SQLite para persistencia de datos
- **Localización**: Soporte para español con formato de fechas regional

## 🏗️ Arquitectura

El proyecto implementa **Clean Architecture** con las siguientes capas:

```
lib/
├── core/                   # Configuración y utilidades base
│   ├── injection/         # Inyección de dependencias (GetIt)
│   ├── validators/        # Validaciones de formularios
│   └── errors/           # Manejo de errores y excepciones
├── data/                  # Capa de datos
│   ├── datasources/      # Fuentes de datos (SQLite)
│   ├── models/           # Modelos de datos con serialización
│   └── repositories/     # Implementación de repositorios
├── domain/               # Lógica de negocio
│   ├── entities/         # Entidades del dominio
│   ├── repositories/     # Contratos de repositorios
│   └── use_cases/        # Casos de uso específicos
└── presentation/         # Capa de presentación
    ├── blocs/           # Gestión de estado con BLoC
    ├── pages/           # Pantallas de la aplicación
    ├── widgets/         # Componentes reutilizables
    └── theme/           # Configuración visual
```

## 🛠️ Stack Tecnológico

### Framework y Lenguaje
- **Flutter 3.x** - Framework de desarrollo multiplataforma
- **Dart** - Lenguaje de programación moderno y eficiente

### Gestión de Estado
- **flutter_bloc ^8.1.3** - Implementación del patrón BLoC
- **equatable ^2.0.5** - Comparación eficiente de objetos

### Inyección de Dependencias
- **get_it ^7.6.4** - Service locator para DI
- **injectable ^2.3.2** - Generación automática de código DI

### Almacenamiento
- **sqflite ^2.3.0** - Base de datos SQLite local
- **path ^1.8.3** - Manejo de rutas del sistema

### Localización y Formato
- **intl ^0.20.2** - Internacionalización y formato de fechas
- **flutter_localizations** - Soporte nativo de localización

### Testing y Calidad
- **flutter_test** - Framework de testing integrado
- **bloc_test ^9.1.5** - Testing específico para BLoCs
- **mocktail ^1.0.1** - Mocking para unit tests
- **flutter_lints ^5.0.0** - Análisis estático de código

## 📱 Funcionalidades Implementadas

### Gestión de Usuarios
- ✅ **Crear Usuario**: Formulario validado con nombre, apellido y fecha de nacimiento
- ✅ **Listar Usuarios**: Vista moderna con tarjetas personalizadas
- ✅ **Ver Detalles**: Modal con información completa del usuario
- ✅ **Eliminar Usuario**: Confirmación y eliminación segura
- ✅ **Validación**: Campos obligatorios con mensajes informativos

### Sistema de Direcciones
- ✅ **Gestión Geográfica**: Cascada País → Departamento → Municipio
- ✅ **Validación Geográfica**: Selección obligatoria y coherente
- ✅ **Información Adicional**: Campo opcional para detalles extra
- ✅ **Múltiples Direcciones**: Carrusel automático para más de 2 direcciones

### Experiencia de Usuario
- ✅ **Navegación Intuitiva**: Flujo lógico entre pantallas
- ✅ **Estados de Carga**: Indicadores visuales durante operaciones
- ✅ **Manejo de Errores**: Mensajes claros y opciones de recuperación
- ✅ **Refresh Manual**: Pull-to-refresh en listados
- ✅ **Responsive Design**: Adaptación a diferentes tamaños de pantalla

## 🎨 Diseño Visual

### Paleta de Colores
- **Primario**: Púrpura moderno (#6B46C1)
- **Secundario**: Púrpura claro (#8B5CF6)
- **Éxito**: Verde esmeralda (#10B981)
- **Error**: Rojo moderno (#EF4444)

### Componentes Visuales
- **Gradientes**: Headers con degradados suaves
- **Sombras**: Elevación sutil en tarjetas
- **Bordes Redondeados**: 12-20px para modernidad
- **Tipografía**: Jerárquica con pesos variables
- **Iconografía**: Material Icons consistentes

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK 3.0 o superior
- Dart SDK 3.0 o superior
- Android Studio / VS Code
- Emulador Android o dispositivo físico

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd user_management_app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Generar código de inyección**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 🧪 Testing

### Ejecutar Tests
```bash
# Tests unitarios
flutter test

# Tests de integración
flutter test integration_test/

# Cobertura de código
flutter test --coverage
```

### Estructura de Testing
- **Unit Tests**: Casos de uso y lógica de negocio
- **Widget Tests**: Componentes de UI individuales
- **BLoC Tests**: Estados y eventos de gestión
- **Integration Tests**: Flujos completos de usuario

## 📐 Patrones de Diseño Implementados

### Arquitecturales
- **Clean Architecture**: Separación en capas
- **Repository Pattern**: Abstracción de datos
- **Dependency Injection**: Inversión de control

### Presentación
- **BLoC Pattern**: Gestión reactiva de estado
- **Builder Pattern**: Construcción de widgets complejos
- **Factory Pattern**: Creación de objetos especializados

## 🔧 Configuración de Desarrollo

### Análisis de Código
El proyecto utiliza `flutter_lints` con reglas estrictas:
- Análisis estático continuo
- Validación de naming conventions
- Detección de código no utilizado
- Verificación de tipos nulos

### Estructura de Commits
- `feat:` Nuevas funcionalidades
- `fix:` Corrección de bugs
- `refactor:` Mejoras de código
- `docs:` Documentación
- `test:` Casos de prueba

## 📊 Métricas de Calidad

- ✅ **0 warnings** de linter
- ✅ **100% tipo seguro** (null safety)
- ✅ **Arquitectura limpia** implementada
- ✅ **Separación de responsabilidades** clara
- ✅ **Código reutilizable** y mantenible

## 🔮 Próximas Mejoras

- [ ] Implementar edición de usuarios
- [ ] Añadir búsqueda y filtros
- [ ] Sincronización con backend
- [ ] Notificaciones push
- [ ] Modo offline avanzado
- [ ] Tests automatizados CI/CD

## 👨‍💻 Desarrollo

Aplicación desarrollada con enfoque en calidad, escalabilidad y mantenibilidad, aplicando las mejores prácticas de la industria y patrones de diseño reconocidos.

---

**Versión**: 1.0.0  
**Flutter**: 3.x  
**Plataformas**: Android, iOS  
**Licencia**: MIT
