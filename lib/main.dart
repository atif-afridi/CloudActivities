import 'package:cloud_bucket/viewmodels/intent_model_provider.dart';
import 'package:cloud_bucket/widgets/upload_screen.dart';
import 'package:cloud_bucket/widgets/view_activities_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => IntentModelProvider()),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/upload': (context) => UploadScreen(),
        '/view': (context) => ViewIntentsScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/upload'),
              child: const Text('Upload Activity'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/view'),
              child: const Text('View Activities'),
            ),
          ],
        ),
      ),
    );
  }
}
