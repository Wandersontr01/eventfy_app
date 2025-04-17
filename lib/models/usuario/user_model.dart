// lib/models/usuario/user_model.dart

class UserModel {
  final String nome; // Nome completo do usuário
  final String email; // E-mail para cadastro e comunicação
  final String genero; // Gênero (Masculino, Feminino, Prefiro não informar)
  final String cidade; // Cidade (relacionada ao estado selecionado)
  final String estado; // Estado do usuário
  final String idioma; // Idioma preferido (Português, Inglês, Espanhol, Outro)
  final List<String> formatoPreferido; // Presencial, Virtual ou ambos
  final int distanciaMaximaKm; // Distância máxima para eventos presenciais
  final String dataNascimento; // Data de nascimento (formato: dd/MM/yyyy)
  final List<String> diasDisponiveis; // Dias da semana disponíveis
  final List<String> horarioPreferido; // Manhã, Tarde, Noite
  final List<String> preferencias; // Preferências de eventos (ex: Música, Cinema, etc.)

  UserModel({
    required this.nome,
    required this.email,
    required this.genero,
    required this.cidade,
    required this.estado,
    required this.idioma,
    required this.formatoPreferido,
    required this.distanciaMaximaKm,
    required this.dataNascimento,
    required this.diasDisponiveis,
    required this.horarioPreferido,
    required this.preferencias,
  });

  // Método para converter o modelo para um mapa (útil para Firestore, por exemplo)
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'genero': genero,
      'cidade': cidade,
      'estado': estado,
      'idioma': idioma,
      'formatoPreferido': formatoPreferido,
      'distanciaMaximaKm': distanciaMaximaKm,
      'dataNascimento': dataNascimento,
      'diasDisponiveis': diasDisponiveis,
      'horarioPreferido': horarioPreferido,
      'preferencias': preferencias,
    };
  }

  // Método para criar o modelo a partir de um mapa (útil para Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      genero: map['genero'] ?? '',
      cidade: map['cidade'] ?? '',
      estado: map['estado'] ?? '',
      idioma: map['idioma'] ?? '',
      formatoPreferido: List<String>.from(map['formatoPreferido'] ?? []),
      distanciaMaximaKm: map['distanciaMaximaKm'] ?? 0,
      dataNascimento: map['dataNascimento'] ?? '',
      diasDisponiveis: List<String>.from(map['diasDisponiveis'] ?? []),
      horarioPreferido: List<String>.from(map['horarioPreferido'] ?? []),
      preferencias: List<String>.from(map['preferencias'] ?? []),
    );
  }
}
