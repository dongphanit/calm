import 'package:calm/screens/favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Avatar & name
              CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=12',
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "My Profile",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),

              /// Option list
              GestureDetector(
                onTap: () {
                  // Handle profile edit
                     Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoriteScreen(
                          // Pass any necessary data to the edit screen
                        ),
                      ),
                    );
                  
                },
                child: 
              _buildOption(Icons.favorite_border, "Favorites"),
              ),
              // _buildOption(Icons.download_outlined, "Downloads"),
              // _buildOption(Icons.settings, "Settings"),
              _buildOption(Icons.help_outline, "Help & Support"),
              // _buildOption(Icons.logout, "Log Out"),

              const Spacer(),

              Text(
                "App version 1.0.0",
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 16),
          Text(
            label,
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Icon(Icons.chevron_right, color: Colors.white38),
        ],
      ),
    );
  }
}
