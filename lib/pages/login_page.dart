import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home_page.dart';

final supabase = Supabase.instance.client;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _userId;

  @override
  void initState() {
    super.initState();

    // Vérifier l'état de la session à l'initialisation
    final session = supabase.auth.currentSession;
    if (session != null) {
      _userId = session.user.id;
      // Si l'utilisateur est déjà connecté, redirige vers la page d'accueil
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      });
    }

    // Écouter les changements d'état de l'authentification
    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });

      // Si l'utilisateur est connecté, redirige vers la page d'accueil
      if (_userId != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      }
    });
  }

  Future<void> _signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '',
      serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '',
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return; // L'utilisateur a annulé la connexion

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw 'Missing Google authentication tokens';
    }

    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (response.session != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      }
    } else {
      throw 'Login failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/MaxTonPote.png',
              width: 400,
              height: 400,
            ),
            const SizedBox(height: 20),
            Text(_userId ?? 'Veuillez vous connecter pour accéder à l\'application'),
            ElevatedButton(
              onPressed: _signInWithGoogle,
              child: const Text('Connexion avec Google'),
            ),
          ],
        ),
      ),
    );
  }
}
