import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

    supabase.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_userId ?? 'Not signed in'),
            ElevatedButton(
              onPressed: () async {
                final GoogleSignIn googleSignIn = GoogleSignIn(
                  clientId: dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? '', // Client ID iOS
                  serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '', // Client ID Web
                );

                final googleUser = await googleSignIn.signIn();
                if (googleUser == null) {
                  return; // L'utilisateur a annulé la connexion
                }

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

                if (response.error != null) {
                  throw response.error!.message;
                }
              },
              child: const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}

extension on AuthResponse {
  get error => null;
}
