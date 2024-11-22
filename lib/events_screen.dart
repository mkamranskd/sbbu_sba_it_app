import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/utils/constant/colors.dart';

class EventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events", style: TextStyle(color: ITColors.textWhite),),
        backgroundColor: ITColors.barbackground,
      ),
      body: Center(
        child: Container(
          width: 360,
          height: 640,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 364,
                  height: 40,

                ),
              ),
              Positioned(
                left: 17,
                top: 6,
                child: SizedBox(
                  width: 171,
                  height: 30,
                  child: Text(
                    'Recent Events',
                    style: TextStyle(
                      color: Color(0xFF207D8A),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20,
                top: 57,
                child: Container(
                  width: 320,
                  height: 97,
                  decoration: ShapeDecoration(
                    color: Color(0xFFF3EEEE),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 123,
                top: 70,
                child: Text(
                  'Film Screening',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              Positioned(
                left: 123,
                top: 100,
                child: SizedBox(
                  width: 203,
                  height: 23,
                  child: Text(
                    'Diary - The Book of Dreams',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w300,
                      height: 1.2,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 33,
                top: 66,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/81x71"),
                      fit: BoxFit.fill,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
