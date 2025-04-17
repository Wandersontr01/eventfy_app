import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/responsive_generic_container.dart';
import '../../models/event_types_model.dart';
import '../../services/ibge_service.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKeys = List.generate(3, (_) => GlobalKey<FormState>());

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  final TextEditingController idiomaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  final IbgeService ibgeService = IbgeService();
  List<String> cidadesDisponiveis = [];
  String? cidadeSelecionada;
  bool carregandoCidades = false;

  String? generoSelecionado;
  String? estadoSelecionado;
  List<String> formatosSelecionados = [];
  List<String> preferenciasSelecionadas = [];
  double distanciaMaxima = 0;

  final List<String> estadosBrasil = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
  ];

  Future<void> _selecionarDataNascimento() async {
    DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );
    if (data != null) {
      setState(() {
        dataNascimentoController.text = DateFormat('dd/MM/yyyy').format(data);
      });
    }
  }

  void _goToNextTab() {
    if (_formKeys[_tabController.index].currentState!.validate()) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  void _submitForm() {
    for (int i = 0; i < _formKeys.length; i++) {
      final currentForm = _formKeys[i].currentState;
      if (currentForm == null || !currentForm.validate()) {
        _tabController.animateTo(i);
        return;
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso!')),
    );
  }

  Widget _label(String texto, {bool obrigatorio = false}) {
    return RichText(
      text: TextSpan(
        text: texto,
        style: const TextStyle(color: Colors.white),
        children:
            obrigatorio
                ? [
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ]
                : [],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pessoais'),
            Tab(text: 'Preferências'),
            Tab(text: 'Conta'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Aba 1
                ResponsiveGenericContainer(
                  child: Form(
                    key: _formKeys[0],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Nome completo', obrigatorio: true),
                        TextFormField(
                          controller: nomeController,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu nome',
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Campo obrigatório'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        _label('Gênero', obrigatorio: true),
                        DropdownButtonFormField<String>(
                          value: generoSelecionado,
                          items:
                              ['Masculino', 'Feminino', 'Prefiro não informar']
                                  .map(
                                    (g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(g),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (val) => setState(() => generoSelecionado = val),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Campo obrigatório'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        _label('Estado', obrigatorio: true),
                        DropdownButtonFormField<String>(
                          menuMaxHeight: 300,
                          value: estadoSelecionado,
                          items:
                              estadosBrasil
                                  .map(
                                    (uf) => DropdownMenuItem(
                                      value: uf,
                                      child: Text(uf),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (val) async {
                            setState(() {
                              estadoSelecionado = val;
                              cidadeSelecionada = null;
                              cidadesDisponiveis = [];
                              carregandoCidades = true;
                            });

                            try {
                              final cidades = await ibgeService
                                  .buscarMunicipiosPorEstado(val!);
                              setState(() {
                                cidadesDisponiveis = cidades;
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro ao buscar cidades: $e'),
                                ),
                              );
                            } finally {
                              setState(() {
                                carregandoCidades = false;
                              });
                            }
                          },
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Campo obrigatório'
                                      : null,
                        ),

                        const SizedBox(height: 16),
                        _label('Cidade', obrigatorio: true),
                        carregandoCidades
                            ? const CircularProgressIndicator()
                            : DropdownButtonFormField<String>(
                              menuMaxHeight: 300,
                              value: cidadeSelecionada,
                              items:
                                  cidadesDisponiveis
                                      .map(
                                        (cidade) => DropdownMenuItem(
                                          value: cidade,
                                          child: Text(cidade),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (val) =>
                                      setState(() => cidadeSelecionada = val),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Campo obrigatório'
                                          : null,
                            ),

                        const SizedBox(height: 16),
                        _label('Idioma preferido', obrigatorio: true),
                        DropdownButtonFormField<String>(
                          value:
                              idiomaController.text.isNotEmpty
                                  ? idiomaController.text
                                  : null,
                          items:
                              ['Português', 'Inglês', 'Espanhol']
                                  .map(
                                    (lang) => DropdownMenuItem(
                                      value: lang,
                                      child: Text(lang),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (val) =>
                                  setState(() => idiomaController.text = val!),
                          decoration: const InputDecoration(
                            hintText: 'Selecione o idioma',
                            isDense: true,
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Campo obrigatório'
                                      : null,
                        ),

                        const SizedBox(height: 16),
                        _label('Data de nascimento', obrigatorio: true),
                        TextFormField(
                          controller: dataNascimentoController,
                          readOnly: true,
                          onTap: _selecionarDataNascimento,
                          decoration: const InputDecoration(
                            hintText: 'DD/MM/AAAA',
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Campo obrigatório'
                                      : null,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _goToNextTab,
                            child: const Text('Próximo'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Aba 2
                ResponsiveGenericContainer(
                  child: Form(
                    key: _formKeys[1],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('Formato preferido', obrigatorio: true),
                        Wrap(
                          spacing: 10,
                          children:
                              ['Presencial', 'Virtual', 'Ambos'].map((formato) {
                                return FilterChip(
                                  label: Text(formato),
                                  selected: formatosSelecionados.contains(
                                    formato,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        formatosSelecionados.add(formato);
                                      } else {
                                        formatosSelecionados.remove(formato);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 16),
                        _label('Distância máxima (km)', obrigatorio: true),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              distanciaMaxima == 200
                                  ? 'Qualquer distância'
                                  : '${distanciaMaxima.round()} km',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Slider(
                              value: distanciaMaxima,
                              min: 0,
                              max: 200,
                              divisions: 20,
                              label:
                                  distanciaMaxima == 200
                                      ? 'Qualquer distância'
                                      : '${distanciaMaxima.round()} km',
                              onChanged: (value) {
                                setState(() => distanciaMaxima = value);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _label('Preferências de eventos', obrigatorio: true),
                        Wrap(
                          spacing: 10,
                          children:
                              EventTypes.all.map((tipo) {
                                return FilterChip(
                                  label: Text(tipo),
                                  selected: preferenciasSelecionadas.contains(
                                    tipo,
                                  ),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        preferenciasSelecionadas.add(tipo);
                                      } else {
                                        preferenciasSelecionadas.remove(tipo);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: _goToNextTab,
                            child: const Text('Próximo'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Aba 3
                ResponsiveGenericContainer(
                  child: Form(
                    key: _formKeys[2],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label('E-mail', obrigatorio: true),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu e-mail',
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Campo obrigatório'
                                      : null,
                        ),
                        const SizedBox(height: 16),
                        _label('Senha', obrigatorio: true),
                        TextFormField(
                          controller: senhaController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Digite sua senha',
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Campo obrigatório'
                                      : null,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: const Text('Cadastrar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
