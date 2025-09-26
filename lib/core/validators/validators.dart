class Validators {
  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El nombre es requerido';
    }
    if (value.length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    if (value.length > 50) {
      return 'El nombre no puede tener más de 50 caracteres';
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'El apellido es requerido';
    }
    if (value.length < 2) {
      return 'El apellido debe tener al menos 2 caracteres';
    }
    if (value.length > 50) {
      return 'El apellido no puede tener más de 50 caracteres';
    }
    return null;
  }

  static String? validateBirthDate(DateTime? value) {
    if (value == null) {
      return 'La fecha de nacimiento es requerida';
    }

    final now = DateTime.now();
    final age = now.year - value.year;

    if (age < 0) {
      return 'La fecha de nacimiento no puede ser futura';
    }
    if (age > 120) {
      return 'La edad no puede ser mayor a 120 años';
    }
    if (age < 13) {
      return 'Debe ser mayor de 13 años';
    }

    return null;
  }

  static String? validateCountry(String? value) {
    if (value == null || value.isEmpty) {
      return 'El país es requerido';
    }
    if (value.length < 2) {
      return 'El país debe tener al menos 2 caracteres';
    }
    return null;
  }

  static String? validateDepartment(String? value) {
    if (value == null || value.isEmpty) {
      return 'El departamento es requerido';
    }
    if (value.length < 2) {
      return 'El departamento debe tener al menos 2 caracteres';
    }
    return null;
  }

  static String? validateMunicipality(String? value) {
    if (value == null || value.isEmpty) {
      return 'El municipio es requerido';
    }
    if (value.length < 2) {
      return 'El municipio debe tener al menos 2 caracteres';
    }
    return null;
  }

  static String? validateStreet(String? value) {
    if (value == null || value.isEmpty) {
      return 'La dirección es requerida';
    }
    if (value.length < 5) {
      return 'La dirección debe tener al menos 5 caracteres';
    }
    if (value.length > 200) {
      return 'La dirección no puede tener más de 200 caracteres';
    }
    return null;
  }

  static String? validateAdditionalInfo(String? value) {
    if (value != null && value.length > 100) {
      return 'La información adicional no puede tener más de 100 caracteres';
    }
    return null;
  }
}
