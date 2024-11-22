import 'package:flutter/material.dart';
import 'package:sbbu_sba_it_app/utils/constant/sizes.dart';
import 'package:sbbu_sba_it_app/utils/constant/text_string.dart';
import 'package:sbbu_sba_it_app/utils/helpers/helper_functions.dart';
import 'package:sbbu_sba_it_app/utils/constant/image_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          children: const [
            OnBoardingPage(
              image: ITImages.onBoardingImage1,
              title: ITTexts.onBoardingSubTitle1,
              subTitle: ITTexts.onBoardingSubTitle1,
            ),
            OnBoardingPage(
              image: ITImages.onBoardingImage2,
              title: ITTexts.onBoardingSubTitle2,
              subTitle: ITTexts.onBoardingSubTitle2,
            ),
            OnBoardingPage(
              image: ITImages.onBoardingImage1,
              title: ITTexts.onBoardingSubTitle3,
              subTitle: ITTexts.onBoardingSubTitle3,
            ),
          ],
        ),
        Positioned(
          top: kToolbarHeight, right: ITSizes.defaultSpace,
          child: TextButton(onPressed: () {}, child: const Text('Skip')),
        ),
      ],
    ));
  }
}

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ITSizes.defaultSpace),
      child: Column(
        children: [
          Image(
            width: THelperFunctions.screenWidth() * 0.8,
            height: THelperFunctions.screenHeight() * 0.6,
            image: AssetImage(image),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: ITSizes.spaceBtwItems),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
