import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'book_screen.dart';
import 'completeMessageScreen.dart';
import 'main.dart';
import 'events_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentImageIndex = 0;
  final List<String> _images = [
    'https://www.sbbusba.edu.pk/images/slider/1.jpg',
    'https://www.sbbusba.edu.pk/images/slider/2.jpg',
    'https://www.sbbusba.edu.pk/images/slider/3.jpg',
    'https://www.sbbusba.edu.pk/images/slider/4.jpg',
    'https://www.sbbusba.edu.pk/images/slider/5.jpg',
    'https://www.sbbusba.edu.pk/images/slider/6.jpg',
    'https://www.sbbusba.edu.pk/images/slider/7.jpg',
    'https://www.sbbusba.edu.pk/images/slider/8.jpg',
    'https://www.sbbusba.edu.pk/images/slider/9.jpg',
    'https://www.sbbusba.edu.pk/images/slider/10.jpg',
    'https://www.sbbusba.edu.pk/images/slider/10.jpg',
  ];

  final PageController _pageController = PageController();
  final PageController _messageController = PageController();
  late Future<List<Map<String, dynamic>>> _messagesFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the messages future
    _messagesFuture = fetchMessages();

    // Set up the periodic image slider
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentImageIndex + 1) % _images.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentImageIndex = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot snapshot = await firestore
          .collection('officialsMessages')
          .doc('personalities')
          .collection('messages')
          .orderBy('timestamp') // Ordering by timestamp
          .get();

      List<Map<String, dynamic>> messages = snapshot.docs.map((doc) {
        return {
          'name': doc['name'],
          'imageUrl': doc['imageUrl'],
          'postTitle': doc['postTitle'],
          'message': doc['message'],
        };
      }).toList();

      return messages;
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/sbbuBarLogo.png',
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemCount: _images.length,
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            _images[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 8.0,
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: _images.length,
                        effect: WormEffect(
                          dotHeight: 8.0,
                          dotWidth: 8.0,
                          spacing: 8.0,
                          activeDotColor: Colors.blue,
                          dotColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            createMessageHeading("University Officials"),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_messageController.page! > 0) {
                        _messageController.previousPage(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Icon(
                                EvaIcons.arrow_left,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _messagesFuture, // Use the pre-initialized future
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text('No messages available.'));
                        } else {
                          final messages = snapshot.data!;
                          return PageView.builder(
                            controller: _messageController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return MessageCard(
                                name: message['name'],
                                imageUrl: message['imageUrl'],
                                postTitle: message['postTitle'],
                                message: message['message'],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_messageController.page! < 4) {
                        _messageController.nextPage(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Center(
                              child: Icon(
                                EvaIcons.arrow_right,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            createMessageHeading("News & Events"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Row(
                  children: [
                    buildCustomContainer(
                      screen: DashboardScreen(selectedIndex: 3),
                      image: 'assets/images/announcement.png',
                      title: 'Announcements',
                      subtitle: '',
                      gradientColors: const [
                        Color(0xFF26C6DA),
                        Color(0xFFEF5350)
                      ],
                    ),
                    buildCustomContainer(
                      screen: EventsScreen(),
                      image: 'assets/images/events.png',
                      title: 'Events',
                      subtitle: '',
                      gradientColors: const [
                        Color(0xFF26C6DA),
                        Color(0xFFEF5350)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            createMessageHeading("Students"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Row(
                    children: [
                      buildCustomContainer(
                        screen: DashboardScreen(selectedIndex: 5),
                        image: 'assets/images/check.png',
                        title: 'SBBU - SAMS',
                        subtitle: '',
                        gradientColors: const [
                          Color(0xFF009688),
                          Color(0xFF4DB6AC),
                        ],
                      ),
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/iconimages/timetable.png',
                        title: 'Time Tables',
                        subtitle: '',
                        gradientColors: const [
                          Color(0xFF2E7D32),
                          Color(0xFF66BB6A),
                        ],
                      ),
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/images/online-course.png',
                        title: 'Courses Outlines',
                        subtitle: '',
                        gradientColors: const [
                          Color(0xFFD32F2F),
                          Color(0xFFE57373),
                        ],
                      ),
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/iconimages/books.png',
                        title: 'Library',
                        subtitle: '',
                        gradientColors: const [
                          Color(0xFF512DA8),
                          Color(0xFF673AB7),
                        ],
                      ),
                    ],
                  )),
            ),
            createMessageHeading("Faculty & Staff"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                child: Row(
                  children: [
                    buildCustomContainer(
                      screen: TimeTableScreen(),
                      image: 'assets/iconimages/timetable.png',
                      title: 'Faculty & Staff',
                      subtitle: '',
                      gradientColors: const [
                        Color(0xFF795548),
                        Color(0xFFA1887F),
                      ],
                    ),
                    buildCustomContainer(
                      screen: TimeTableScreen(),
                      image: 'assets/images/presentation.png',
                      title: 'Class Schedules',
                      subtitle: '',
                      gradientColors: const [
                        Color(0xFF1565C0),
                        Color(0xFF1E88E5),
                      ],
                    ),
                    buildCustomContainer(
                      screen: TimeTableScreen(),
                      image: 'assets/iconimages/books.png',
                      title: 'Faculty & Staff',
                      subtitle: '',
                      gradientColors: const [
                        Color(0xFF455A64),
                        Color(0xFF78909C),
                      ],
                    ),
                    buildCustomContainer(
                      screen: TimeTableScreen(),
                      image: 'assets/iconimages/books.png',
                      title: 'Faculty & Staff',
                      subtitle: '',
                      gradientColors: const [
                        Color(0xFF26C6DA),
                        Color(0xFFEF5350)
                      ],
                    ),
                  ],
                ),
              ),
            ),
            createMessageHeading("About"),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Row(
                    children: [
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/images/treasure-map.png',
                        title: 'Campus Map',
                        subtitle: '',
                        gradientColors: const [
                          Color(0xFF673AB7),
                          Color(0xFF9575CD),
                        ],
                      ),
                      buildCustomContainer(
                        screen: DashboardScreen(selectedIndex: 6),
                        image: 'assets/images/helpDesk.png',
                        title: 'Help Desk',
                        subtitle: '',
                        gradientColors: const [
                          Color(0xFF0288D1),
                          Color(0xFF039BE5),
                        ],
                      ),
                      /*buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/iconimages/books.png',
                        title: 'Settings',
                        subtitle: '',
                        gradientColors: const [
                          Color(0xFF26C6DA),
                          Color(0xFFEF5350)
                        ],
                      ),*/
                    ],
                  )),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "App Version: 1.0",
                    style: GoogleFonts.lato(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            /*GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoadMessagesScreen()),
                );
              },
              child: ZoomTapAnimation(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 110,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                        colors: const [
                          Color(0xFF0288D1),
                          Color(0xFF039BE5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Load",
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SaveMessageScreen()),
                );
              },
              child: ZoomTapAnimation(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    height: 110,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      gradient: LinearGradient(
                        colors: const [
                          Color(0xFF0288D1),
                          Color(0xFF039BE5),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Save",
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

  Widget buildCustomContainer(
      {required String image,
      required String title,
      required String subtitle,
      required List<Color> gradientColors,
      required Widget screen}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: ZoomTapAnimation(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            height: 110,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    image,
                    height: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  subtitle != ''
                      ? Text(
                          subtitle,
                          style: GoogleFonts.lato(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget createMessageHeading(String title) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}

class MessageCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String postTitle;
  final String message;

  const MessageCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.postTitle,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              name: name,
              imageUrl: imageUrl,
              postTitle: postTitle,
              message: message,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 2),
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue.shade400, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imageUrl != ""
                  ? CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue.shade200,
                      child: CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage(imageUrl),
                      ),
                    )
                  : SizedBox.shrink(),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    name != ''
                        ? Text(
                            name,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          )
                        : SizedBox.shrink(),
                    postTitle != ''
                        ? Text(
                            postTitle,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : SizedBox.shrink(),
                    const SizedBox(height: 5),
                    message != ''
                        ? Text(
                            message.length > 100
                                ? '${message.substring(0, 100)}... Read More'
                                : message,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
