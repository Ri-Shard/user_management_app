import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_management_app/domain/use_cases/use_cases.dart'
    as use_cases;
import 'package:user_management_app/presentation/blocs/address/address_event.dart';
import 'package:user_management_app/presentation/blocs/address/address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final use_cases.GetUserAddresses getUserAddresses;
  final use_cases.AddAddress addAddress;
  final use_cases.UpdateAddress updateAddress;
  final use_cases.DeleteAddress deleteAddress;
  final use_cases.GetCountries getCountries;
  final use_cases.GetDepartmentsByCountry getDepartmentsByCountry;
  final use_cases.GetMunicipalitiesByDepartment getMunicipalitiesByDepartment;

  AddressBloc({
    required this.getUserAddresses,
    required this.addAddress,
    required this.updateAddress,
    required this.deleteAddress,
    required this.getCountries,
    required this.getDepartmentsByCountry,
    required this.getMunicipalitiesByDepartment,
  }) : super(AddressInitial()) {
    on<LoadUserAddresses>(_onLoadUserAddresses);
    on<CreateAddress>(_onCreateAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<RefreshAddresses>(_onRefreshAddresses);
    on<LoadCountries>(_onLoadCountries);
    on<LoadDepartments>(_onLoadDepartments);
    on<LoadMunicipalities>(_onLoadMunicipalities);
  }

  Future<void> _onLoadUserAddresses(
    LoadUserAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());

    final result = await getUserAddresses(event.userId);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressLoaded(addresses)),
    );
  }

  Future<void> _onCreateAddress(
    CreateAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());

    final result = await addAddress(event.address);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (address) => emit(AddressCreated(address)),
    );
  }

  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());

    final result = await updateAddress(event.address);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (address) => emit(AddressUpdated(address)),
    );
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());

    final result = await deleteAddress(event.addressId);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => emit(AddressDeleted(event.addressId)),
    );
  }

  Future<void> _onRefreshAddresses(
    RefreshAddresses event,
    Emitter<AddressState> emit,
  ) async {
    final result = await getUserAddresses(event.userId);
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressLoaded(addresses)),
    );
  }

  Future<void> _onLoadCountries(
    LoadCountries event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());

    try {
      final countries = await getCountries.call();
      emit(CountriesLoaded(countries));
    } catch (e) {
      emit(AddressError('Error al cargar países: $e'));
    }
  }

  Future<void> _onLoadDepartments(
    LoadDepartments event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());

    try {
      final departments = await getDepartmentsByCountry.call(event.countryId);
      emit(DepartmentsLoaded(departments));
    } catch (e) {
      emit(AddressError('Error al cargar departamentos: $e'));
    }
  }

  Future<void> _onLoadMunicipalities(
    LoadMunicipalities event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());

    try {
      final municipalities = await getMunicipalitiesByDepartment.call(
        event.departmentId,
      );
      emit(MunicipalitiesLoaded(municipalities));
    } catch (e) {
      emit(AddressError('Error al cargar municipios: $e'));
    }
  }
}
