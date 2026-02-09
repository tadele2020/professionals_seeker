import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutDeveloper extends StatelessWidget {
  const AboutDeveloper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About the Developer', style: GoogleFonts.poppins()),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const // የነበረው CircleAvatar ክፍል
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blueAccent,
              // ፎቶህን እዚህ ጋር ነው የምትተካው
              backgroundImage: const AssetImage('assets/developer.jpg'),
            ),
            const SizedBox(height: 20),
            Text(
              'Tadele Tilahun',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 30),

            // የሙያ ዝርዝሮች
            _buildInfoTile(Icons.email, 'tadele005@gmail.com'),
            _buildInfoTile(Icons.language, 'www.softmed-2fe32.web.app'),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Professional Profiles:',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // የሙያ ብቃቶች ዝርዝር
            _buildProfessionChip('Pharmacist'),
            _buildProfessionChip('Health Officer'),
            _buildProfessionChip('Software Engineer'),
            _buildProfessionChip('CISCO Certified'),
            _buildProfessionChip('Electrician'),

            const SizedBox(height: 40),
            Text(
              'SOFTMED IT Solutions\nProviding professional multi-disciplinary services.',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansEthiopic(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(text, style: GoogleFonts.poppins(fontSize: 15)),
    );
  }

  Widget _buildProfessionChip(String label) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified, size: 20, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
