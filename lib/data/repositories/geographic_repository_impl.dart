import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/repositories/geographic_repository.dart';

class GeographicRepositoryImpl implements GeographicRepository {
  // Solo Colombia
  static final List<Country> _countries = [
    const Country(id: '1', name: 'Colombia', code: 'CO'),
  ];

  static final List<Department> _departments = [
    // Departamentos de Colombia
    const Department(id: '1', name: 'Amazonas', countryId: '1'),
    const Department(id: '2', name: 'Antioquia', countryId: '1'),
    const Department(id: '3', name: 'Arauca', countryId: '1'),
    const Department(id: '4', name: 'Atlántico', countryId: '1'),
    const Department(id: '5', name: 'Bolívar', countryId: '1'),
    const Department(id: '6', name: 'Boyacá', countryId: '1'),
    const Department(id: '7', name: 'Caldas', countryId: '1'),
    const Department(id: '8', name: 'Caquetá', countryId: '1'),
    const Department(id: '9', name: 'Casanare', countryId: '1'),
    const Department(id: '10', name: 'Cauca', countryId: '1'),
    const Department(id: '11', name: 'Cesar', countryId: '1'),
    const Department(id: '12', name: 'Chocó', countryId: '1'),
    const Department(id: '13', name: 'Córdoba', countryId: '1'),
    const Department(id: '14', name: 'Cundinamarca', countryId: '1'),
    const Department(id: '15', name: 'Guainía', countryId: '1'),
    const Department(id: '16', name: 'Guaviare', countryId: '1'),
    const Department(id: '17', name: 'Huila', countryId: '1'),
    const Department(id: '18', name: 'La Guajira', countryId: '1'),
    const Department(id: '19', name: 'Magdalena', countryId: '1'),
    const Department(id: '20', name: 'Meta', countryId: '1'),
    const Department(id: '21', name: 'Nariño', countryId: '1'),
    const Department(id: '22', name: 'Norte de Santander', countryId: '1'),
    const Department(id: '23', name: 'Putumayo', countryId: '1'),
    const Department(id: '24', name: 'Quindío', countryId: '1'),
    const Department(id: '25', name: 'Risaralda', countryId: '1'),
    const Department(
      id: '26',
      name: 'San Andrés y Providencia',
      countryId: '1',
    ),
    const Department(id: '27', name: 'Santander', countryId: '1'),
    const Department(id: '28', name: 'Sucre', countryId: '1'),
    const Department(id: '29', name: 'Tolima', countryId: '1'),
    const Department(id: '30', name: 'Valle del Cauca', countryId: '1'),
    const Department(id: '31', name: 'Vaupés', countryId: '1'),
    const Department(id: '32', name: 'Vichada', countryId: '1'),
    const Department(id: '33', name: 'Bogotá D.C.', countryId: '1'),
  ];

  static final List<Municipality> _municipalities = [
    // Amazonas
    const Municipality(id: '1', name: 'Leticia', departmentId: '1'),
    const Municipality(id: '2', name: 'El Encanto', departmentId: '1'),
    const Municipality(id: '3', name: 'La Chorrera', departmentId: '1'),
    const Municipality(id: '4', name: 'La Pedrera', departmentId: '1'),
    const Municipality(id: '5', name: 'La Victoria', departmentId: '1'),
    const Municipality(id: '6', name: 'Miriti - Paraná', departmentId: '1'),
    const Municipality(id: '7', name: 'Puerto Alegría', departmentId: '1'),
    const Municipality(id: '8', name: 'Puerto Arica', departmentId: '1'),
    const Municipality(id: '9', name: 'Puerto Nariño', departmentId: '1'),
    const Municipality(id: '10', name: 'Puerto Santander', departmentId: '1'),
    const Municipality(id: '11', name: 'Tarapacá', departmentId: '1'),

    // Antioquia
    const Municipality(id: '12', name: 'Medellín', departmentId: '2'),
    const Municipality(id: '13', name: 'Bello', departmentId: '2'),
    const Municipality(id: '14', name: 'Itagüí', departmentId: '2'),
    const Municipality(id: '15', name: 'Envigado', departmentId: '2'),
    const Municipality(id: '16', name: 'Apartadó', departmentId: '2'),
    const Municipality(id: '17', name: 'Turbo', departmentId: '2'),
    const Municipality(id: '18', name: 'Rionegro', departmentId: '2'),
    const Municipality(id: '19', name: 'Copacabana', departmentId: '2'),
    const Municipality(id: '20', name: 'La Estrella', departmentId: '2'),
    const Municipality(id: '21', name: 'Sabaneta', departmentId: '2'),
    const Municipality(id: '22', name: 'Girardota', departmentId: '2'),
    const Municipality(id: '23', name: 'Barbosa', departmentId: '2'),
    const Municipality(id: '24', name: 'Caldas', departmentId: '2'),
    const Municipality(id: '25', name: 'La Ceja', departmentId: '2'),
    const Municipality(id: '26', name: 'Guarne', departmentId: '2'),
    const Municipality(id: '27', name: 'Guatapé', departmentId: '2'),
    const Municipality(id: '28', name: 'El Retiro', departmentId: '2'),
    const Municipality(id: '29', name: 'San Jerónimo', departmentId: '2'),
    const Municipality(
      id: '30',
      name: 'Santafé de Antioquia',
      departmentId: '2',
    ),
    const Municipality(id: '31', name: 'Santa Rosa de Osos', departmentId: '2'),
    const Municipality(id: '32', name: 'Sonsón', departmentId: '2'),
    const Municipality(id: '33', name: 'Yarumal', departmentId: '2'),
    const Municipality(id: '34', name: 'Yolombó', departmentId: '2'),
    const Municipality(id: '35', name: 'Zaragoza', departmentId: '2'),

    // Arauca
    const Municipality(id: '36', name: 'Arauca', departmentId: '3'),
    const Municipality(id: '37', name: 'Arauquita', departmentId: '3'),
    const Municipality(id: '38', name: 'Cravo Norte', departmentId: '3'),
    const Municipality(id: '39', name: 'Fortul', departmentId: '3'),
    const Municipality(id: '40', name: 'Puerto Rondón', departmentId: '3'),
    const Municipality(id: '41', name: 'Saravena', departmentId: '3'),
    const Municipality(id: '42', name: 'Tame', departmentId: '3'),

    // Atlántico
    const Municipality(id: '43', name: 'Barranquilla', departmentId: '4'),
    const Municipality(id: '44', name: 'Soledad', departmentId: '4'),
    const Municipality(id: '45', name: 'Malambo', departmentId: '4'),
    const Municipality(id: '46', name: 'Puerto Colombia', departmentId: '4'),
    const Municipality(id: '47', name: 'Galapa', departmentId: '4'),
    const Municipality(id: '48', name: 'Sabanalarga', departmentId: '4'),
    const Municipality(id: '49', name: 'Baranoa', departmentId: '4'),
    const Municipality(id: '50', name: 'Usiacurí', departmentId: '4'),
    const Municipality(id: '51', name: 'Tubará', departmentId: '4'),
    const Municipality(id: '52', name: 'Ponedera', departmentId: '4'),
    const Municipality(id: '53', name: 'Repelón', departmentId: '4'),
    const Municipality(id: '54', name: 'Sabanagrande', departmentId: '4'),
    const Municipality(id: '55', name: 'Suan', departmentId: '4'),
    const Municipality(id: '56', name: 'Santo Tomás', departmentId: '4'),
    const Municipality(id: '57', name: 'Santa Lucía', departmentId: '4'),
    const Municipality(id: '58', name: 'Manatí', departmentId: '4'),
    const Municipality(id: '59', name: 'Luruaco', departmentId: '4'),
    const Municipality(id: '60', name: 'Juan de Acosta', departmentId: '4'),
    const Municipality(id: '61', name: 'Candelaria', departmentId: '4'),
    const Municipality(id: '62', name: 'Campo de la Cruz', departmentId: '4'),
    const Municipality(id: '63', name: 'Palmar de Varela', departmentId: '4'),
    const Municipality(id: '64', name: 'Piojó', departmentId: '4'),
    const Municipality(id: '65', name: 'Polonuevo', departmentId: '4'),

    // Bolívar
    const Municipality(id: '66', name: 'Cartagena', departmentId: '5'),
    const Municipality(id: '67', name: 'Magangué', departmentId: '5'),
    const Municipality(id: '68', name: 'Mompós', departmentId: '5'),
    const Municipality(id: '69', name: 'Turbaco', departmentId: '5'),
    const Municipality(id: '70', name: 'Arjona', departmentId: '5'),
    const Municipality(id: '71', name: 'Mahates', departmentId: '5'),
    const Municipality(id: '72', name: 'San Pablo', departmentId: '5'),
    const Municipality(id: '73', name: 'Santa Rosa', departmentId: '5'),
    const Municipality(id: '74', name: 'Simití', departmentId: '5'),
    const Municipality(id: '75', name: 'Tiquisio', departmentId: '5'),
    const Municipality(id: '76', name: 'Villanueva', departmentId: '5'),
    const Municipality(id: '77', name: 'Zambrano', departmentId: '5'),
    const Municipality(id: '78', name: 'Achí', departmentId: '5'),
    const Municipality(id: '79', name: 'Altos del Rosario', departmentId: '5'),
    const Municipality(id: '80', name: 'Arenal', departmentId: '5'),
    const Municipality(id: '81', name: 'Arroyohondo', departmentId: '5'),
    const Municipality(id: '82', name: 'Barranco de Loba', departmentId: '5'),
    const Municipality(id: '83', name: 'Calamar', departmentId: '5'),
    const Municipality(id: '84', name: 'Cantagallo', departmentId: '5'),
    const Municipality(id: '85', name: 'Cicuco', departmentId: '5'),
    const Municipality(id: '86', name: 'Córdoba', departmentId: '5'),
    const Municipality(id: '87', name: 'Clemencia', departmentId: '5'),
    const Municipality(
      id: '88',
      name: 'El Carmen de Bolívar',
      departmentId: '5',
    ),
    const Municipality(id: '89', name: 'El Guamo', departmentId: '5'),
    const Municipality(id: '90', name: 'El Peñón', departmentId: '5'),
    const Municipality(id: '91', name: 'Hatillo de Loba', departmentId: '5'),
    const Municipality(id: '92', name: 'Margarita', departmentId: '5'),
    const Municipality(id: '93', name: 'María la Baja', departmentId: '5'),
    const Municipality(id: '94', name: 'Montecristo', departmentId: '5'),
    const Municipality(id: '95', name: 'Morales', departmentId: '5'),
    const Municipality(id: '96', name: 'Norosí', departmentId: '5'),
    const Municipality(id: '97', name: 'Pinillos', departmentId: '5'),
    const Municipality(id: '98', name: 'Regidor', departmentId: '5'),
    const Municipality(id: '99', name: 'Río Viejo', departmentId: '5'),
    const Municipality(id: '100', name: 'San Cristóbal', departmentId: '5'),
    const Municipality(id: '101', name: 'San Estanislao', departmentId: '5'),
    const Municipality(id: '102', name: 'San Fernando', departmentId: '5'),
    const Municipality(id: '103', name: 'San Jacinto', departmentId: '5'),
    const Municipality(
      id: '104',
      name: 'San Jacinto del Cauca',
      departmentId: '5',
    ),
    const Municipality(
      id: '105',
      name: 'San Juan Nepomuceno',
      departmentId: '5',
    ),
    const Municipality(
      id: '106',
      name: 'San Martín de Loba',
      departmentId: '5',
    ),
    const Municipality(id: '107', name: 'Santa Catalina', departmentId: '5'),
    const Municipality(
      id: '108',
      name: 'Santa Rosa del Sur',
      departmentId: '5',
    ),
    const Municipality(id: '109', name: 'Soplaviento', departmentId: '5'),
    const Municipality(id: '110', name: 'Talaigua Nuevo', departmentId: '5'),
    const Municipality(id: '111', name: 'Turbaná', departmentId: '5'),

    // Boyacá
    const Municipality(id: '112', name: 'Tunja', departmentId: '6'),
    const Municipality(id: '113', name: 'Duitama', departmentId: '6'),
    const Municipality(id: '114', name: 'Sogamoso', departmentId: '6'),
    const Municipality(id: '115', name: 'Chiquinquirá', departmentId: '6'),
    const Municipality(id: '116', name: 'Paipa', departmentId: '6'),
    const Municipality(id: '117', name: 'Villa de Leyva', departmentId: '6'),
    const Municipality(id: '118', name: 'Puerto Boyacá', departmentId: '6'),
    const Municipality(id: '119', name: 'Moniquirá', departmentId: '6'),
    const Municipality(id: '120', name: 'Garagoa', departmentId: '6'),
    const Municipality(id: '121', name: 'Muzo', departmentId: '6'),
    const Municipality(id: '122', name: 'Nobsa', departmentId: '6'),
    const Municipality(id: '123', name: 'Ráquira', departmentId: '6'),
    const Municipality(id: '124', name: 'Samacá', departmentId: '6'),
    const Municipality(id: '125', name: 'Sutamarchán', departmentId: '6'),
    const Municipality(id: '126', name: 'Tenza', departmentId: '6'),
    const Municipality(id: '127', name: 'Tibasosa', departmentId: '6'),
    const Municipality(id: '128', name: 'Tota', departmentId: '6'),
    const Municipality(id: '129', name: 'Tununguá', departmentId: '6'),
    const Municipality(id: '130', name: 'Turmequé', departmentId: '6'),
    const Municipality(id: '131', name: 'Tuta', departmentId: '6'),
    const Municipality(id: '132', name: 'Úmbita', departmentId: '6'),
    const Municipality(id: '133', name: 'Ventaquemada', departmentId: '6'),
    const Municipality(id: '134', name: 'Viracachá', departmentId: '6'),
    const Municipality(id: '135', name: 'Zetaquira', departmentId: '6'),

    // Bogotá D.C.
    const Municipality(id: '136', name: 'Bogotá', departmentId: '33'),
  ];

  @override
  Future<List<Country>> getCountries() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));
    return _countries;
  }

  @override
  Future<List<Department>> getDepartmentsByCountry(String countryId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    return _departments.where((dept) => dept.countryId == countryId).toList();
  }

  @override
  Future<List<Municipality>> getMunicipalitiesByDepartment(
    String departmentId,
  ) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 300));
    return _municipalities
        .where((mun) => mun.departmentId == departmentId)
        .toList();
  }
}
