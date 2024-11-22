import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sbbu_sba_it_app/classroom_screen.dart';
import 'package:sbbu_sba_it_app/profile_screen.dart';
import 'package:sbbu_sba_it_app/staff_screen.dart';
import 'package:sbbu_sba_it_app/utils/themeapp/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sbbu_sba_it_app/nottification_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jafar Abbas',
      themeMode: ThemeMode.light,
      theme: ITAppTheme.lightTheme,
      darkTheme: ITAppTheme.darkTheme,
      home: DashboardScreen(selectedIndex: 0),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  final int selectedIndex;

  const DashboardScreen({super.key, required this.selectedIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _selectedIndex;
  final List<Widget> _screens = [
    HomeScreen(),
    const StaffScreen(),
    ClassroomScreen(),
    const NotificationScreen(),
    ProfileScreen(),
    SimpleWebView(
        link: 'https://app.sbbusba.edu.pk/sams/index.php', pageName: 'Official Page'),
    SimpleWebView(
        link: 'https://www.sbbusba.edu.pk/sbbu-main/helpdesk.html',
        pageName: 'Official HelpDesk Page'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*  appBar: AppBar(
     title: const Text('SBBU IT APP', style: TextStyle(color : ITColors.bartext),),
        backgroundColor: ITColors.backgroundbar,

        // Set color to green
        elevation: 0, // Remove elevation
        centerTitle: true, // Align the title to center
        iconTheme: const IconThemeData(color: Colors.white), // Set icon color
        titleTextStyle: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white, // Set title text color to white
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Drawer Header', style: TextStyle(color: ITColors.bartext),),
              decoration: BoxDecoration(
                color: Color(0xFF043D48),

              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Profile'),
              onTap: () {
                // Navigate to profile screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Navigate to settings screen
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Downloads'),
              onTap: () {
                // Navigate to Admin Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DownloadScreen()),
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Switch to Admin'),
              onTap: () {
                // Navigate to Admin Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminPanel()),
                );
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.arrow_drop_down_circle_sharp),
              title: const Text('About'),
              onTap: () {
                // Navigate to Admin Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),*/
      body: _screens[_selectedIndex],
      bottomNavigationBar: SalomonBottomBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue.withOpacity(0.3),
        backgroundColor: Colors.white12,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.admin_panel_settings),
            title: Text('About Staff'),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.join_full),
            title: Text('Classroom'),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.notifications),
            title: Text("Notifications"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
      ),
    );
  }
}

class SimpleWebView extends StatelessWidget {
  final String link;
  final String pageName;

  SimpleWebView({
    super.key,
    required this.link,
    required this.pageName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageName),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..setJavaScriptMode(JavaScriptMode.disabled)
          ..loadRequest(Uri.parse(link)),
      ),
    );
  }
}
