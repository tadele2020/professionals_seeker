import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SpecificationPage extends StatefulWidget {
  const SpecificationPage({super.key});

  @override
  State<SpecificationPage> createState() => _SpecificationPageState();
}

class _SpecificationPageState extends State<SpecificationPage> {
  // false = Amharic, true = English
  bool isEnglish = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEnglish ? 'Specifications' : 'ዝርዝር መግለጫዎች'),
        backgroundColor: const Color(0xFF1967D2),
        foregroundColor: Colors.white,
        actions: [
          // Language Toggle Switch
          Row(
            children: [
              Text(
                isEnglish ? 'EN' : 'አማ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Switch(
                value: isEnglish,
                activeColor: Colors.white,
                activeTrackColor: Colors.purple[300],
                onChanged: (value) {
                  setState(() {
                    isEnglish = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Center(
              child: Text(
                isEnglish ? 'Connecting Work and Workers' : 'ሥራና ሠራተኛን ለማገናኘት',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansEthiopic(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1967D2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),

            // Content
            _buildInfoText(
              amharic: 'ሥራ ና ባለሙያን በቀላሉ ለማገናኘት የተሰራ መተግበሪያ ነው',
              english:
                  'An application designed to easily connect jobs and professionals.',
            ),
            _buildInfoText(
              amharic: 'ፎርሞቹን በእንግሊዝኛ፣ በአማርኛ፣ በሲዳምኛ እና በኦሮምኛ መሙላት ይቻላል።',
              english:
                  'Forms can be filled in English, Amharic, Sidamic, and Oromiffa.',
            ),
            _buildInfoText(
              amharic: 'ለሥራ ፈላጊም ሆነ ለባለሙያ ፈላጊ 50 ብር ቅድሚያ ያስከፍላል።',
              english:
                  'Both job seekers and employers are required to pay 50 Birr upfront.',
            ),

            // Bank Info Box
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: _buildInfoText(
                amharic:
                    'በንግድ ባንክ አካውንት ቁጥር 1000071977114 በመክፈል ከባንክ የተሰጥዎትን ID: FT26039FTF90 ዓይነት ቁጥር ፎርሙ ላይ ሞልተው ይላኩ (50 ብር ያልተላከበት ፎርም ዋጋ የለውም ወዲያው ከዳታ ቤዝ ይሰረዛል)።',
                english:
                    'Pay via Commercial Bank of Ethiopia (CBE) Account No: 1000071977114 and enter the Bank ID (e.g., FT26039FTF90) on the form. (Forms without the 50 Birr payment are invalid and will be deleted from the database).',
              ),
            ),

            _buildInfoText(
              amharic:
                  'ገንዘቡ መድረስ አለመድረሱን መመዝገብ አለመመዝገቦን በ 0916823674 ድውለው ማረጋገጥ ይችላሉ (ባይደውሉም ምንም ችግር የለም)።',
              english:
                  'You can verify your registration and payment by calling 0916823674 (optional).',
            ),

            _buildInfoText(
              amharic:
                  'ሥራው ከተገኘና ቅጥሩ ከተፈፀመ በሁለቱም ወገን የሠራተኛውን ደሞዝ 8% እያንዳንዳቸው አንዴ ብቻ ይከፍላሉ።',
              english:
                  'Once employment is secured, both parties will pay a one-time commission of 8% of the monthly gross salary.',
            ),

            // Example Section
            _buildInfoText(
              amharic:
                  'ማለትም፡\n• አሰሪው ድርጅት 8% (ለምሳሌ ደሞዝ 1000 ቢሆን 80 ብር)\n• ባለሙያው 8% (ለምሳሌ ደሞዝ 1000 ቢሆን 80 ብር)',
              english:
                  'Example:\n• Employer: 8% (e.g., if salary is 1000, pay 80 Birr)\n• Professional: 8% (e.g., if salary is 1000, pay 80 Birr)',
            ),

            const Divider(),
            const SizedBox(height: 10),

            // Other Services
            Text(
              isEnglish ? 'Other Services:' : 'የተለያዩ አገልግሎቶችን ለማግኘት፡',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            _buildBulletPoint(
              isEnglish ? 'System Software Development' : 'የሲስተም ሶፍትዌር ስራዎች',
            ),
            _buildBulletPoint(
              isEnglish
                  ? 'Web Page & Mobile App Development'
                  : 'ዌብ ፔጅ እና ሞባይል አፕ ለማሰራት',
            ),
            _buildBulletPoint(
              isEnglish
                  ? 'SOP Documentation Preparation'
                  : 'የ SOP ዶክመንቶች እንዲዘጋጅሎት',
            ),
            _buildBulletPoint(
              isEnglish
                  ? 'Network Installation & Maintenance'
                  : 'ኔትዎርክ ለማዘርጋት እና ለመጠገን',
            ),
            _buildBulletPoint(
              isEnglish ? 'EFDA Applications' : 'የ EFDA ማመልከቻዎችን ለመላክ',
            ),
            _buildBulletPoint(
              isEnglish
                  ? 'Electrical & Sanitary Installation'
                  : 'የኤሌክትሪክ ና የውኃ ዝርጋታ',
            ),

            const SizedBox(height: 30),

            // Contact Footer
            Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                color: Colors.yellow[100],
                child: Text(
                  isEnglish
                      ? 'For any issues or suggestions, call 0916823674 for immediate response.'
                      : 'ለማንኛውም ጉዳይ ና አስተያየት በ 0916823674 ስልክ ቢደውሉ ወዲያው መልስ እንሰጣለን።',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for information text
  Widget _buildInfoText({required String amharic, required String english}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        isEnglish ? english : amharic,
        style: GoogleFonts.notoSansEthiopic(fontSize: 16, height: 1.5),
      ),
    );
  }

  // Helper widget for list items
  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.notoSansEthiopic(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
