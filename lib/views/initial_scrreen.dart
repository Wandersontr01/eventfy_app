import 'package:flutter/material.dart';
import '../widgets/responsive_button.dart';
import '../widgets/responsive_container.dart';
import 'usuario/cadastro_usuario_view.dart';
// import 'login/login_view.dart'; // descomentar após criação da tela de login
// import 'organizador/cadastro_organizador_view.dart'; // descomentar após criação da tela de organizador

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/imagens/eventfy-logo.png',
              height: MediaQuery.of(context).size.width < 400 ? 100 : 150,
            ),
            const SizedBox(height: 40),
            ResponsiveButton(
              onPressed: () {
                // TODO: criar LoginView
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const LoginView()),
                // );
              },
              text: 'Login',
              icon: Icons.login,
              isPrimary: true,
            ),
            const SizedBox(height: 30),
            const Text(
              'Não tem cadastro? Faça agora:',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 20),
            ResponsiveButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastroUsuarioView(),
                  ),
                );
              },
              text: 'Cadastro Usuário',
              icon: Icons.person_add,
              isPrimary: true,
            ),
            const SizedBox(height: 10),
            ResponsiveButton(
              onPressed: () {
                // TODO: Criar CadastroOrganizadorView e importar
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const CadastroOrganizadorView(),
                //   ),
                // );
              },
              text: 'Cadastro Organizador',
              icon: Icons.business_outlined,
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }
}