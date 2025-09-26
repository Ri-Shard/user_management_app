import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/repositories/geographic_repository.dart';

class GetMunicipalitiesByDepartment {
  final GeographicRepository repository;

  GetMunicipalitiesByDepartment(this.repository);

  Future<List<Municipality>> call(String departmentId) async {
    return await repository.getMunicipalitiesByDepartment(departmentId);
  }
}
