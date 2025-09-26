import 'package:user_management_app/domain/entities/entities.dart';
import 'package:user_management_app/domain/repositories/geographic_repository.dart';

class GetCountries {
  final GeographicRepository repository;

  GetCountries(this.repository);

  Future<List<Country>> call() async {
    return await repository.getCountries();
  }
}
