import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gestao_frota/telas/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String erro = '';
  try {
    //Conecta no Firebase usando o arquivo android/app/google-services.json
    await Firebase.initializeApp();
  } catch (e) {
    erro = e.toString();
  }
  runApp(MyApp(erro));
}

class MyApp extends StatelessWidget {
  final String erro;

  const MyApp(this.erro, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestão de Frota',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: erro.isEmpty ? Home() : TelaErro(erro),
    );
  }
}

//Aparece só se o Firebase não conectar (ex.: rodou no Chrome ou falta o google-services.json)
class TelaErro extends StatelessWidget {
  final String erro;

  const TelaErro(this.erro, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Não foi possível conectar ao Firebase.\n'
            'Rode o app no emulador Android e confira o google-services.json.\n\n$erro',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
