import 'package:aahar/util/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Navigation Bar
            const NavBar(),

            // Hero Section
            const HeroSection(),

            // Process Flow Section
            ProcessFlowSection(),

            // Impact Stats Section
            // ImpactStatsSection(isMobile: isMobile),

            // Call To Action
            // CallToActionSection(isMobile: isMobile),

            // Footer
            // Footer(isMobile: isMobile),
          ],
        ),
      ),
    );
  }
}

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildDesktopNavBar(context),
    );
  }

  Widget _buildDesktopNavBar(BuildContext context) {
    return Row(
      children: [
        Text(
          'Aahar - Kitchen',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Spacer(),
        // const NavLink(title: 'Home'),
        // const NavLink(title: 'About'),
        // const NavLink(title: 'Impact'),
        // const NavLink(title: 'Volunteer'),
        // const NavLink(title: 'Contact'),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            // Login logic
            context.go(Routes.login);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).colorScheme.primary,
            side: BorderSide(color: Theme.of(context).colorScheme.primary),
          ),
          child: const Text('Login'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            // Sign up logic
            context.go(Routes.signup);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}

class NavLink extends StatelessWidget {
  final String title;

  const NavLink({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () {},
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      bool isMobile = constraint.maxWidth < 600;
      return Container(
        // width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 80,
          vertical: isMobile ? 40 : 64,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
            ],
          ),
        ),
        child: isMobile
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context),
      );
    });
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Fighting Hunger,\nFueling Communities',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Revolutionizing food management from shopping to delivery for those who need it most.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Get Started'),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_circle_outline),
                    label: const Text('See how it works'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        // Expanded(
        //   child: Image.network(
        //     '/api/placeholder/600/400',
        //     fit: BoxFit.cover,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Fighting Hunger,\nFueling Communities',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            height: 1.2,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Revolutionizing food management from shopping to delivery for those who need it most.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        // Image.network(
        //   '/api/placeholder/600/400',
        //   fit: BoxFit.cover,
        // ),
        // const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Get Started'),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.play_circle_outline),
          label: const Text('See how it works'),
        ),
      ],
    );
  }
}

class ProcessFlowSection extends StatelessWidget {
  const ProcessFlowSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      final bool isMobile = cons.maxWidth < 600;
      return Container(
        width: double.infinity,
        padding:
            EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80, vertical: 64),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              'Our Kitchen Management Process',
              textAlign: TextAlign.center,
              style: GoogleFonts.playfairDisplay(
                fontSize: isMobile ? 28 : 36,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Efficiently managing food from procurement to plate',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 64),
            isMobile
                ? _buildMobileProcessSteps(context)
                : _buildDesktopProcessSteps(context),
          ],
        ),
      );
    });
  }

  Widget _buildDesktopProcessSteps(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildProcessStep(
            context,
            Icons.shopping_cart,
            'Shopping',
            'Sourcing fresh ingredients from local suppliers and minimizing waste',
          ),
        ),
        _buildProcessConnector(),
        Expanded(
          child: _buildProcessStep(
            context,
            Icons.kitchen,
            'Preparation',
            'Washing, chopping, and organizing ingredients for efficient cooking',
          ),
        ),
        _buildProcessConnector(),
        Expanded(
          child: _buildProcessStep(
            context,
            Icons.restaurant,
            'Cooking',
            'Creating nutritious meals in our state-of-the-art kitchen facilities',
          ),
        ),
        _buildProcessConnector(),
        Expanded(
          child: _buildProcessStep(
            context,
            Icons.delivery_dining,
            'Delivery',
            'Distributing meals to communities in need with care and dignity',
          ),
        ),
      ],
    );
  }

  Widget _buildMobileProcessSteps(BuildContext context) {
    return Column(
      children: [
        _buildProcessStep(
          context,
          Icons.shopping_cart,
          'Shopping',
          'Sourcing fresh ingredients from local suppliers and minimizing waste',
          isMobile: true,
        ),
        _buildVerticalConnector(),
        _buildProcessStep(
          context,
          Icons.kitchen,
          'Preparation',
          'Washing, chopping, and organizing ingredients for efficient cooking',
          isMobile: true,
        ),
        _buildVerticalConnector(),
        _buildProcessStep(
          context,
          Icons.restaurant,
          'Cooking',
          'Creating nutritious meals in our state-of-the-art kitchen facilities',
          isMobile: true,
        ),
        _buildVerticalConnector(),
        _buildProcessStep(
          context,
          Icons.delivery_dining,
          'Delivery',
          'Distributing meals to communities in need with care and dignity',
          isMobile: true,
        ),
      ],
    );
  }

  Widget _buildProcessStep(
      BuildContext context, IconData icon, String title, String description,
      {bool isMobile = false}) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(
            icon,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessConnector() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40),
          Icon(
            Icons.arrow_forward,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalConnector() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Icon(
        Icons.arrow_downward,
        color: Colors.black26,
      ),
    );
  }
}

class ImpactStatsSection extends StatelessWidget {
  final bool isMobile;

  const ImpactStatsSection({Key? key, required this.isMobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80, vertical: 64),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          Text(
            'Our Impact',
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Making a difference in our community every day',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 48),
          isMobile ? _buildMobileStats() : _buildDesktopStats(),
        ],
      ),
    );
  }

  Widget _buildDesktopStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem('10,000+', 'Meals Delivered'),
        _buildStatItem('500+', 'Volunteers'),
        _buildStatItem('25+', 'Community Partners'),
        _buildStatItem('5+', 'Years of Service'),
      ],
    );
  }

  Widget _buildMobileStats() {
    return Column(
      children: [
        _buildStatItem('10,000+', 'Meals Delivered'),
        const SizedBox(height: 32),
        _buildStatItem('500+', 'Volunteers'),
        const SizedBox(height: 32),
        _buildStatItem('25+', 'Community Partners'),
        const SizedBox(height: 32),
        _buildStatItem('5+', 'Years of Service'),
      ],
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class CallToActionSection extends StatelessWidget {
  final bool isMobile;

  const CallToActionSection({Key? key, required this.isMobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(horizontal: isMobile ? 24 : 80, vertical: 64),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 24 : 48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            ),
            child: Column(
              children: [
                Text(
                  'Ready to Make a Difference?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: isMobile ? 28 : 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Join our team of volunteers or donate to support our mission of fighting hunger in the community.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 24 : 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Volunteer'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor:
                            Theme.of(context).colorScheme.secondary,
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.secondary),
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 24 : 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Donate'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
