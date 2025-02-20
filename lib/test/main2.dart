import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  await Supabase.initialize(
      url: "https://yfzhelrrtbfuzeissvlu.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlmemhlbHJydGJmdXplaXNzdmx1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk5NzU3MzAsImV4cCI6MjA1NTU1MTczMH0.WUmZbjslko7xspPXmno3Y6UBVOoZN-QP2OQ48Vjkn_0",
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

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
          children: [
            Text(_userId ?? 'Not signed in'),
            ElevatedButton(
              onPressed: () async {
                /// TODO: update the Web client ID with your own.
                ///
                /// Web Client ID that you registered with Google Cloud.
                const webClientId = '622077126537-0198hc4pbo19u2gqu5n39avsac22f57c.apps.googleusercontent.com';

                /// TODO: update the iOS client ID with your own.
                ///
                /// iOS Client ID that you registered with Google Cloud.
                const iosClientId = '622077126537-0i3cpo83nc6p2nqb62uajm5j530q17l9.apps.googleusercontent.com';

                // Google sign in on Android will work without providing the Android
                // Client ID registered on Google Cloud.

                final GoogleSignIn googleSignIn = GoogleSignIn(
                  clientId: iosClientId,
                  serverClientId: webClientId,
                );
                final googleUser = await googleSignIn.signIn();
                final googleAuth = await googleUser!.authentication;
                final accessToken = googleAuth.accessToken;
                final idToken = googleAuth.idToken;

                if (accessToken == null) {
                  throw 'No Access Token found.';
                }
                if (idToken == null) {
                  throw 'No ID Token found.';
                }

                await supabase.auth.signInWithIdToken(
                  provider: OAuthProvider.google,
                  idToken: idToken,
                  accessToken: accessToken,
                );
              },
              child: const Text('Sign in with google'),
            )
          ],
        ),
      ),
    );
  }
}
