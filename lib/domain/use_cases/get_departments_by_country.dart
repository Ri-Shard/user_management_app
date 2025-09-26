import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/repositories/geographic_repository.dart';

class GetDepartmentsByCountry {
  final GeographicRepository repository;

  GetDepartmentsByCountry(this.repository);

  Future<List<Department>> call(String countryId) async {
    return await repository.getDepartmentsByCountry(countryId);
  }
}
