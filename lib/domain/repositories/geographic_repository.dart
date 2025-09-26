import 'package:user_management_app/domain/entities/entities.dart';

abstract class GeographicRepository {
  Future<List<Country>> getCountries();
  Future<List<Department>> getDepartmentsByCountry(String countryId);
  Future<List<Municipality>> getMunicipalitiesByDepartment(String departmentId);
}
