import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:testapp/login_page.dart";
import "package:testapp/signup_page.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        //primarySwatch: const Color.fromARGB(255, 24, 131, 219),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: const SignupPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // final List<CategoryModel> categories = getCategories();
  // final List<DietModel> diets = getDiets();
  // final List<DietModel> popularDiets = getPopularDiets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(),
                const SizedBox(height: 20.0),
                _buildSearchTextField(),
                const SizedBox(height: 20.0),
                // _buildCategorySection(),
                const SizedBox(height: 20.0),
                // _buildRecommendationForDietSection(),
                const SizedBox(height: 20.0),
                // _buildPopularSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 40.0,
            height: 40.0,
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8F8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/menu.svg',
                height: 20.0,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            width: 40.0,
            height: 40.0,
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8F8),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/notification.svg',
                height: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTextField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.11),
            blurRadius: 10.0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              height: 20.0,
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/icons/filter.svg',
                  height: 20.0,
                ),
              ),
              const VerticalDivider(
                thickness: 0.1,
                color: Colors.grey,
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCategorySection(dynamic categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          height: 100.0,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 25.0),
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                width: 100.0,
                decoration: BoxDecoration(
                  color: category.boxColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            category.icon,
                            height: 20.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

  // Widget _buildRecommendationForDietSection(dynamic diets) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Recommendation for Diet',
  //         style: TextStyle(
  //           fontSize: 18.0,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 10.0),
  //       SizedBox(
  //         height: 240.0,
  //         child: ListView.separated(
  //           scrollDirection: Axis.horizontal,
  //           itemCount: diets.length,
  //           separatorBuilder: (context, index) => const SizedBox(width: 25.0),
  //           itemBuilder: (context, index) {
  //             final diet = diets[index];
  //             return Container(
  //               width: 210.0,
  //               decoration: BoxDecoration(
  //                 color: diet.boxColor.withOpacity(0.1),
  //                 borderRadius: BorderRadius.circular(15.0),
  //               ),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(15.0),
  //                         child: SvgPicture.asset(
  //                           diet.icon,
  //                           height: 40.0,
  //                         ),
  //                       ),
  //                       Container(
  //                         width: 130.0,
  //                         height: 45.0,
  //                         decoration: BoxDecoration(
  //                           gradient: LinearGradient(
  //                             colors: diet.isViewSelected
  //                                 ? [
  //                                    const Color(0xFF4B49AC