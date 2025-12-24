import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sandbox/data/hive_data_store.dart';
import 'package:flutter_sandbox/models/tasks.dart';
import 'package:flutter_sandbox/views/main_view.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main()async {

  // Init db before runApp
  await Hive.initFlutter();

  // Register Hive Adapter
  Hive.registerAdapter<Task>(TaskAdapter());

  // Open a box
  Box box = await Hive.openBox<Task>(HiveDataStore.boxName);

  // This step is not necessary it makes task that stay more than a day get deleted
  box.values.forEach((task) {
    if(task.createdAtTime.day != DateTime.now().day){
      task.delete();
    } else{
      // Do nothing
    }
  });

  runApp(BaseWidget(child:  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  )));
}

class BaseWidget extends InheritedWidget{
  BaseWidget({ super.key, required this.child}):super(child: child);
  final HiveDataStore dataStore = HiveDataStore();
  @override
  final Widget child;

  static BaseWidget of(BuildContext context){
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if(base != null){
      return base;
    } else{
      throw StateError('could not find ancestor of widget of type base widget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }
  
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle( const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return const Scaffold(
      body: MainViewPage(),
    );
  }
}
