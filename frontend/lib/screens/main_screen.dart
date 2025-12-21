import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'my_courses_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  const MainScreen({super.key, required this.userData});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Keys to force rebuild when tab changes
  final GlobalKey<MyCoursesScreenState> _myCoursesKey =
      GlobalKey<MyCoursesScreenState>();
  final GlobalKey<ProfileScreenState> _profileKey =
      GlobalKey<ProfileScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreenContent(userData: widget.userData),
          MyCoursesScreen(key: _myCoursesKey, userData: widget.userData),
          ProfileScreen(key: _profileKey, userData: widget.userData),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);

              // Refresh data when switching to specific tabs
              if (index == 1) {
                // "Kursus Saya" tab - refresh pendaftaran
                _myCoursesKey.currentState?.refreshData();
              } else if (index == 2) {
                // "Profil" tab - refresh stats
                _profileKey.currentState?.refreshStats();
              }
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.indigo,
            unselectedItemColor: Colors.grey[400],
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school_outlined),
                activeIcon: Icon(Icons.school),
                label: 'Kursus Saya',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Home Screen Content (tanpa Scaffold karena sudah di MainScreen)
class HomeScreenContent extends StatefulWidget {
  final Map<String, dynamic> userData;
  const HomeScreenContent({super.key, required this.userData});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  @override
  Widget build(BuildContext context) {
    // Redirect to actual HomeScreen with proper navigation
    return HomeScreen(userData: widget.userData);
  }
}
