import 'package:aahar/features/auth/model/user_model.dart';
import 'package:aahar/util/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.user});
  final UserModel user;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Example user data
    final userDetail = {
      'name': widget.user.name,
      'id': widget.user.id ?? "",
      'email': widget.user.name,
      'role': widget.user.role.toUpperCase(),
      'createdAt': widget.user.createdAt,
    };

    // Format the date
    final dateFormat = DateFormat('MMMM d, yyyy • h:mm a');
    final formattedDate = dateFormat.format(widget.user.createdAt.toDate());

    // Detect if we're on mobile or web
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.indigo.shade50, Colors.white],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 1000 : double.infinity,
                ),
                child: Column(
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: isDesktop
                            ? _buildDesktopLayout(userDetail, formattedDate)
                            : _buildMobileLayout(userDetail, formattedDate),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // TextButton.icon(
                    //   icon: const Icon(Icons.edit),
                    //   label: const Text('Edit Profile'),
                    //   onPressed: () {},
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(Map<String, dynamic> user, String formattedDate) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left side (avatar)
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'profile-picture',
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.indigo.shade100,
                  child: Text(
                    _getInitials(user['name'] as String),
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                user['name'] as String,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user['role'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Right side (details)
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoSection('User ID', user['id'] as String),
              const Divider(height: 32),
              _buildInfoSection('Email', user['email'] as String),
              const Divider(height: 32),
              _buildInfoSection('Account Created', formattedDate),
              const SizedBox(height: 32),
              Container(
                margin: const EdgeInsets.only(top: 24),
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) context.go(Routes.home);
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(Map<String, dynamic> user, String formattedDate) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar and name
        Hero(
          tag: 'profile-picture',
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.indigo.shade100,
            child: Text(
              _getInitials(user['name'] as String),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade800,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          user['name'] as String,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            user['role'] as String,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.indigo.shade800,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection('User ID', user['id'] as String),
            const Divider(height: 32),
            _buildInfoSection('Email', user['email'] as String),
            const Divider(height: 32),
            _buildInfoSection('Account Created', formattedDate),
          ],
        ),
        const SizedBox(height: 32),
        Container(
          margin: const EdgeInsets.only(top: 24),
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) context.go(Routes.home);
            },
          ),
        )
      ],
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getInitials(String name) {
    final nameParts = name.split(' ');
    String initials = '';

    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0];
      }
      if (initials.length >= 2) break;
    }

    return initials.toUpperCase();
  }
}
