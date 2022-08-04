import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:webmfetch/explore.dart';
import 'package:webmfetch/library.dart';
import 'package:webmfetch/settings.dart';
import 'package:webmfetch/vm/explore_view_model.dart';
import 'package:webmfetch/vm/library_view_model.dart';

import 'package:webmfetch/vm/shared_view_model.dart';

final locator = GetIt.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  locator.registerSingleton<SharedViewModel>(SharedViewModel());
  locator.registerSingleton<LibraryViewModel>(LibraryViewModel());
  locator.registerSingleton<ExploreViewModel>(ExploreViewModel());
  if (Platform.isWindows || Platform.isLinux) {
    await DartVLC.initialize(useFlutterNativeView: true);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(
        brightness: brightness,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true);
    return baseTheme;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      title: 'webm.fetch',
      home: const RootPage(title: 'webm.fetch'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final vm = GetIt.instance<SharedViewModel>();
  int selectedPage = 0;

  @override
  void initState() {
    vm.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SharedViewModel>.reactive(
      disposeViewModel: false,
      builder: (context, model, child) => rootScreen(),
      viewModelBuilder: () => vm,
    );
  }

  Widget rootScreen() {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: IndexedStack(
            index: selectedPage,
            children: [
              Navigator(
                initialRoute: '/',
                onGenerateRoute: (RouteSettings settings) {
                  WidgetBuilder builder;
                  switch (settings.name) {
                    case '/':
                      builder = (context) => const Library();
                      break;
                    default:
                      throw Exception("Invalid route: ${settings.name}");
                  }
                  return MaterialPageRoute(
                      builder: builder, settings: settings);
                },
              ),
              Navigator(
                initialRoute: '/',
                onGenerateRoute: (RouteSettings settings) {
                  WidgetBuilder builder;
                  switch (settings.name) {
                    case '/':
                      builder = (context) => const Explore();
                      break;
                    default:
                      throw Exception("Invalid route: ${settings.name}");
                  }
                  return MaterialPageRoute(
                      builder: builder, settings: settings);
                },
              ),
              Navigator(
                initialRoute: '/',
                onGenerateRoute: (RouteSettings settings) {
                  WidgetBuilder builder;
                  switch (settings.name) {
                    case '/':
                      builder = (context) => const Settings();
                      break;
                    default:
                      throw Exception("Invalid route: ${settings.name}");
                  }
                  return MaterialPageRoute(
                      builder: builder, settings: settings);
                },
              )
            ],
          )),
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              selectedPage = index;
            });
          },
          height: 72,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Library'),
            NavigationDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: 'Explore'),
            NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings'),
          ],
          selectedIndex: selectedPage),
    );
  }

  Widget currentScreen() {
    switch (selectedPage) {
      case 0:
        return const Library();
      case 1:
        return const Explore();
      case 2:
        return const Settings();
      default:
        return const Library();
    }
  }
}
