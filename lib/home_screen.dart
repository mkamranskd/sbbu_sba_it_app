import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/utils/constant/it_icon_sizes.dart';
import 'package:sbbu_sba_it_app/utils/themeapp/custum_theme/text_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';
import 'book_screen.dart';
import 'completeMessageScreen.dart';
import 'gallery_screen.dart';
import 'main.dart';
import 'transport_screen.dart';
import 'events_screen.dart';
import 'ppts_screen.dart';
import 'package:sbbu_sba_it_app/class_detail.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';
import 'package:sbbu_sba_it_app/utils/constant/sizes.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:icons_plus/icons_plus.dart';

class HomeScreen extends StatefulWidget {
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
  final PageController _messageBoxController = PageController();

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: ITColors.accent,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/sbbuBarLogo.png',
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
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

            createMessageHeading("University Official's Messages"),

            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_messageBoxController.page! > 0) {
                        _messageBoxController.previousPage(
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
                    child: PageView.builder(
                      controller: _messageBoxController,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return MessageCard(
                            name: 'Engr. Prof. Dr Madad Ali Shah',
                            imageUrl:
                                'https://www.sbbusba.edu.pk/images/eng_prof_dr_madad_ali-vc.jpeg',
                            postTitle: 'Vice Chancellor',
                            message:
                                'I feel immense pride in welcoming you all to our prestigious Alma mater, which is an illustrious landmark in the dissemination of education and learning. Shaheed Benazir Bhutto University, Shaheed Benazirabad, since its inception has been incessantly working and playing a catalytic role in uplifting and enlightening students through quality education. The institution empowers students to acclimatize with the demanding challenges of this ever-growing, innovative world. \n\nWithin a span of just a few years, the university has gained widespread prominence owing to Shaheed Benazir Bhutto\'s ingenious and dedicated services in the very heart of rural Sindh. The university provides students with the qualified, experienced and committed educationists in the roles of teachers, administrators, content developers and policymakers. The faculty is vigorously engaged in inculcating and fostering a research and academic inquiry oriented culture to keep the students well-acquainted with the growing research demands of the modern educational world. The University is truly devoted to have a committed body of teachers and students who are fervently resolute and dedicated to achieve academic excellence, expertise in top-notch research, and enthusiasm that has and will continue to serve the nation.\n\nThe university holds a high-tech and resplendent infrastructure that has been installed in accordance with climate challenges and the increasing educational demands of students. Highly efficient and newfangled security and monitoring systems distinguish the university from neighboring institutions. The university is truly committed to provide you a green, pollution-free, healthy atmosphere that will surely boost and sharpen your academic and intellectual capabilities.\n\nWe also offer a prodigious range of extra-curricular activities, stages and forums for the exploration and exhibition of students’ overall talents, sports, art, entrepreneurship and aesthetic expositions, as well as a multitude of opportunities for volunteering and social services. The provision of these opportunities are profusely significant in character building and personality contouring of the students to become socially enlightened citizens of Pakistan.\n\nShaheed Benazir Bhutto University, Shaheed Benazirabad, diligently inculcates critical thinking, encourages the exploration of new veins of knowledge, promotes collaborative work, infuses multiculturalism and enforces a culture of empathy and humanitarianism.\n\nI, being the Vice Chancellor of Shaheed Benazir Bhutto University, Shaheed Benazirabad, envisage this university to reach the apex of academic excellence. I extend my heartfelt felicitations to you in joining us in this exciting journey towards excellence and distinction.');
                      },
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      if (_messageBoxController.page! < 4) {
                        // Adjust this condition based on data count
                        _messageBoxController.nextPage(
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

                  // Right Arrow Button
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
                        subtitle: 'Events, Notifications &\nCirculars',
                        gradientColors: const [
                          Color(0xFF26C6DA),
                          Color(0xFFEF5350)
                        ],
                      ),

                      buildCustomContainer(
                        screen: EventsScreen(),
                        image: 'assets/images/events.png',
                        title: 'Events',
                        subtitle: 'Events, Notifications &\nCirculars',
                        gradientColors: const [
                          Color(0xFF26C6DA),
                          Color(0xFFEF5350)
                        ],
                      ),
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/images/treasure-map.png',
                        title: 'Campus Map',
                        subtitle: '',
                        gradientColors: const [
                          Color(0xFF673AB7), // Deep Purple
                          Color(0xFF9575CD), // Soft Lavender
                        ],
                      ),
                      buildCustomContainer(
                        screen: DashboardScreen(selectedIndex: 6),
                        image: 'assets/images/helpDesk.png',
                        title: 'Help Desk',
                        subtitle: '',
                        gradientColors: const [
                          Color(0xFF0288D1), // Dark Blue
                          Color(0xFF039BE5), // Medium Blue
                        ],
                      ),
                      /*buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/iconimages/books.png',
                        title: 'Settings',
                        subtitle: 'Personalize\nAdjust Preference',
                        gradientColors: const [
                          Color(0xFF26C6DA),
                          Color(0xFFEF5350)
                        ],
                      ),*/
                    ],
                  )),
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
                        subtitle: 'Attendence Management\nSystem',
                        gradientColors: const [
                          Color(0xFF009688), // Teal
                          Color(0xFF4DB6AC), // Light Teal
                        ],
                      ),
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/iconimages/timetable.png',
                        title: 'Time Tables',
                        subtitle: 'Discover Courses\nExpand Knowledge',
                        gradientColors: const [
                          Color(0xFF2E7D32), // Deep Green
                          Color(0xFF66BB6A), // Medium Green
                        ],
                      ),
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/images/online-course.png',
                        title: 'Courses Outlines',
                        subtitle: 'Stay Organized\nManage Time',
                        gradientColors: const [
                          Color(0xFFD32F2F), // Red
                          Color(0xFFE57373), // Light Red
                        ],
                      ),
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/iconimages/books.png',
                        title: 'Settings',
                        subtitle: 'Personalize\nAdjust Preference',
                        gradientColors: const [
                          Color(0xFF512DA8), // Dark Indigo
                          Color(0xFF673AB7), // Indigo
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
                        subtitle: 'Discover Courses\nExpand Knowledge',
                        gradientColors: const [
                          Color(0xFF795548), // Brown
                          Color(0xFFA1887F), // Light Brown
                        ],
                      ),
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/images/presentation.png',
                        title: 'Class Schedules',
                        subtitle: '',
                        gradientColors: const [
                          Color(0xFF1565C0), // Royal Blue
                          Color(0xFF1E88E5), // Blue
                        ],
                      ),
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/iconimages/books.png',
                        title: 'Faculty & Staff',
                        subtitle: 'Stay Organized\nManage Time',
                        gradientColors: const [
                          Color(0xFF455A64), // Dark Grayish Blue
                          Color(0xFF78909C), // Grayish Blue
                        ],
                      ),
                      buildCustomContainer(
                        screen: TimeTableScreen(),
                        image: 'assets/iconimages/books.png',
                        title: 'Faculty & Staff',
                        subtitle: 'Personalize\nAdjust Preference',
                        gradientColors: const [
                          Color(0xFF26C6DA),
                          Color(0xFFEF5350)
                        ],
                      ),
                    ],
                  )),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              // Padding inside the container
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              // Optional margin around the container
              decoration: BoxDecoration(
                color: Colors.white, // Background color for the container
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3), // Shadow color
                    spreadRadius: 2, // Shadow spread radius
                    blurRadius: 5, // Shadow blur radius
                    offset: Offset(0, 3), // Shadow position offset
                  ),
                ],
              ),
              height: 400,
              // Set a fixed height
              child: GridView.count(
                crossAxisCount: 3, // 4 columns
                mainAxisSpacing: 10.0, // Space between rows
                crossAxisSpacing: 10.0, // Space between columns
                children: [
                  _buildIconButton(context, 'assets/iconimages/timetable.png',
                      'Time Tables', TimeTableScreen()),
                  _buildIconButton(context, 'assets/iconimages/books.png',
                      'Book Library', GalleryScreen()),
                  _buildIconButton(context, 'assets/iconimages/classroom.png',
                      'Classroom', ClassListScreen()),
                  _buildIconButton(context, 'assets/iconimages/bus.png',
                      'Transport', StudentTransportScreen()),
                  _buildIconButton(context, 'assets/iconimages/events.png',
                      'Events', EventsScreen()),
                  _buildIconButton(context, 'assets/iconimages/ppt.png', 'PPTs',
                      PPTsScreen()),
                  _buildIconButton(context, 'assets/iconimages/gallery.png',
                      'Gallery', GalleryScreen()),
                  _buildIconButton(context, 'assets/iconimages/hostel.png',
                      'Hostel', GalleryScreen()),
                  _buildIconButton(context, 'assets/iconimages/form.png',
                      'Form', GalleryScreen()),
                  _buildIconButton(context, 'assets/iconimages/circular.png',
                      'Circular', GalleryScreen()),
                  _buildIconButton(context, 'assets/iconimages/department.png',
                      'Department', GalleryScreen()),
                ],
              ),
            ),
            const SizedBox(height: 10),
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
              //padding: const EdgeInsets.fromLTRB(8, 10, 0, 5),
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(image, height: 30),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Dubai',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  subtitle!=''?
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontFamily: 'Dubai',
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ):SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
      BuildContext context, String imagePath, String label, Widget screen) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        decoration: ShapeDecoration(
          color: ITColors.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: ITIconSizes.iconSizeMedium,
              height: ITIconSizes.iconSizeMedium,
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
            SizedBox(height: ITSizes.sm),
            Text(
              label,
              style: ITTextTheme.lightTextTheme.bodyMedium!.copyWith(
                fontSize: ITSizes.fontSizeSm,
                color: ITColors.textPrimary,
              ),
            ),
          ],
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
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
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.postTitle,
    required this.message,
  }) : super(key: key);

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
              // Avatar with border
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.blue.shade100,
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
              const SizedBox(width: 16),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      postTitle,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      message.length > 100
                          ? '${message.substring(0, 100)}.....'
                          : message,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
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
