import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'about_developer.dart';

class AdditionalServices extends StatelessWidget {
  const AdditionalServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Additional Services',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. System Development
          _buildExpansionTile(
            context,
            title: 'System Development',
            color: Colors.blue[800]!,
            icon: Icons.computer,
            subItems: [
              'Hospital Management System',
              'Clinic Management System',
              'Wholesale Management System',
              'Import And Suppliers Management System',
              'Pharmacy Management System',
            ],
          ),

          const SizedBox(height: 12),

          // 2. Mobile App Development (Converted to Dropdown)
          _buildExpansionTile(
            context,
            title: 'Mobile App Development',
            color: Colors.purple,
            icon: Icons.phone_android,
            subItems: [
              'Any business Oriented Mobile App',
              'Any Non business Oriented Mobile App',
            ],
          ),

          const SizedBox(height: 12),

          // 3. Web Page Development (Converted to Dropdown)
          _buildExpansionTile(
            context,
            title: 'Web Page Development',
            color: Colors.green[700]!,
            icon: Icons.language,
            subItems: [
              'For Business Organizations',
              'For Non Business Organizations',
              'For Individuals',
            ],
          ),

          const SizedBox(height: 12),

          // 4. Networking (Converted to Dropdown)
          _buildExpansionTile(
            context,
            title: 'Networking',
            color: Colors.redAccent[700]!,
            icon: Icons.settings_input_component,
            subItems: [
              'Network Installation',
              'Network Maintenance',
              'Network Configuration',
              'Network Administration',
            ],
          ),

          const SizedBox(height: 12),

          // 5. Apartments And Vilas House
          _buildExpansionTile(
            context,
            title: 'Apartments And Vilas House',
            color: Colors.teal[700]!,
            icon: Icons.home_work,
            subItems: ['Electrical Installation', 'Sanitary Installation'],
          ),

          const SizedBox(height: 12),

          // 6. SOP Documentations
          _buildExpansionTile(
            context,
            title: 'SOP Documentations',
            color: Colors.indigo[900]!,
            icon: Icons.description,
            subItems: [
              'All SOP Documentation Preparations',
              'Quality Manual Documentations',
              'Job Descriptions Documentations',
            ],
          ),

          const SizedBox(height: 12),

          // 7. EFDA Applications
          _buildExpansionTile(
            context,
            title: 'EFDA Applications',
            color: Colors.orange[800]!,
            icon: Icons.assignment,
            subItems: [
              'New Account Creation for new Organization',
              'Store Change Application',
              'Technical Change Application',
              'CAPA Feedback Submission',
              'All Type of Applications',
            ],
          ),

          const SizedBox(height: 40),

          // Contact Link
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutDeveloper(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Text(
                  "Contact And About the Developer ...",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: const Color(0xFF1967D2),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ወጥ የሆነ የ Dropdown (ExpansionTile) መስሪያ ተግባር
  Widget _buildExpansionTile(
    BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
    required List<String> subItems,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: Icon(icon, color: color),
        iconColor: color,
        collapsedIconColor: Colors.grey,
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        children: subItems.map((item) {
          return ListTile(
            dense: true,
            leading: Icon(Icons.check_circle_outline, size: 18, color: color),
            title: Text(
              item,
              style: GoogleFonts.notoSansEthiopic(fontSize: 14),
            ),
            onTap: () {
              // ተግባር ሲፈለግ እዚህ ይገባል
            },
          );
        }).toList(),
      ),
    );
  }
}
