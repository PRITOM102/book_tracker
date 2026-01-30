import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://jrzttpjuxjrecqcbljsm.supabase.co',
    anonKey: 'sb_publishable_8t00zM3kkZqH2qhpGTaz4g_3qZwRhs5',
  );
  
  runApp(const MyApp());
}