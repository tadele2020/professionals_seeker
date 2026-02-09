import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'additional_services.dart';
import 'specification.dart'; // አዲሱ ፋይል
import 'employer_form.dart';
import 'job_seeker_form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOFTMED Professionals Seeker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.notoSansEthiopicTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ቋንቋውን ለመቆጣጠር (false = Amharic, true = English)
  bool isEnglish = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 1. Specifications Link
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SpecificationPage(),
              ),
            );
          },
          child: Text(
            isEnglish ? 'Specifications' : 'ዝርዝር መግለጫዎች',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF1967D2),
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // 2. Language Toggle (Amharic / English)
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                Text(
                  isEnglish ? 'EN' : 'አማ',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Switch(
                  value: isEnglish,
                  activeColor: Colors.purple,
                  onChanged: (bool value) {
                    setState(() {
                      isEnglish = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SOFTMED Logo
              Text(
                'SOFTMED',
                style: GoogleFonts.poppins(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1967D2),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 60),

              // I want Job Button
              _buildLargeButton(
                context,
                text: isEnglish ? 'I want Job' : 'ሥራ ፈላጊ (I want Job)',
                color: Colors.purple,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JobSeekerForm(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // I want Professional Button
              _buildLargeButton(
                context,
                text: isEnglish
                    ? 'I want Professional'
                    : 'ቀጣሪ (I want Professional)',
                color: Colors.purple,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmployerForm(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // ሌሎች አገልግሎቶችን ለማግኘት Link
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdditionalServices(),
                    ),
                  );
                },
                child: Text(
                  isEnglish ? 'For other services' : 'ሌሎች አገልግሎቶችን ለማግኘት',
                  style: GoogleFonts.notoSansEthiopic(
                    fontSize: 16,
                    color: const Color(0xFF1967D2),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ወጥ የሆነ በተን ለመሥራት የሚያገለግል Helper Widget
  Widget _buildLargeButton(
    BuildContext context, {
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.notoSansEthiopic(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
