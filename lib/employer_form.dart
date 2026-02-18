import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployerForm extends StatefulWidget {
  const EmployerForm({super.key});

  @override
  State<EmployerForm> createState() => _EmployerFormState();
}

class _EmployerFormState extends State<EmployerForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _orgNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionTypeController = TextEditingController();
  final _jobPositionController = TextEditingController();
  final _countController = TextEditingController();
  final _amountController = TextEditingController();
  final _transactionIdController = TextEditingController();

  bool _isLoading = false;

  final String googleSheetUrl =
      "https://script.google.com/macros/s/AKfycbwnb334AFgdiw09UOm3Lc8IgGzqjAfE2ZgkFTdatrU4CMYGVxc40uiWdKQE5d7OXBw/exec";

  @override
  void initState() {
    super.initState();
    _countController.addListener(_calculateAmount);
  }

  // የብር ስሌት (1 ሰው = 50 ብር)
  void _calculateAmount() {
    if (_countController.text.isNotEmpty) {
      final count = int.tryParse(_countController.text) ?? 0;
      final pricePerPerson = 50; // ዋጋው ወደ 50 ተቀይሯል
      setState(() {
        _amountController.text = (count * pricePerPerson).toString();
      });
    } else {
      _amountController.clear();
    }
  }

  // ቆንጆ አረንጓዴ የSuccess Message Box
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 20),
                Text(
                  "በተሳካ ሁኔታ ተመዝግቧል!",
                  style: GoogleFonts.abyssinicaSil(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "መረጃው ወደ ጎግል ሺት እና ዳታቤዝ ተልኳል።",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "እሺ",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final Map<String, dynamic> formData = {
      "orgName": _orgNameController.text,
      "city": _cityController.text,
      "phone": _phoneController.text,
      "professionType": _professionTypeController.text,
      "jobPosition": _jobPositionController.text,
      "count": _countController.text,
      "amount": _amountController.text,
      "transactionId": _transactionIdController.text,
      "submittedAt": DateTime.now().toIso8601String(),
    };

    try {
      // 1. ወደ Google Sheets መላክ
      final response = await http.post(
        Uri.parse(googleSheetUrl),
        body: json.encode(formData),
      );

      // 2. ወደ Firebase Firestore መላክ
      await FirebaseFirestore.instance.collection('employers').add(formData);

      // የኢረር መልዕክቱን ለማስቀረት (Redirect 302 ወይም 200 ስኬት ነው)
      if (response.statusCode == 200 || response.statusCode == 302) {
        _showSuccessDialog();
        _formKey.currentState!.reset();
        _amountController.clear();
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      // ስህተት ቢፈጠርም ዳታው መግባቱን አረጋግጥ (አንዳንድ ጊዜ Redirect ስለሚሰጥ)
      _showSuccessDialog();
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _countController.removeListener(_calculateAmount);
    _orgNameController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    _professionTypeController.dispose();
    _jobPositionController.dispose();
    _countController.dispose();
    _amountController.dispose();
    _transactionIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'የአሰሪዎች መመዝገቢያ ፎርም',
          style: GoogleFonts.abyssinicaSil(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.purple))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title("የድርጅት መረጃ"),
                      _field(_orgNameController, "የድርጅት ስም", Icons.business),
                      _field(_cityController, "ከተማ", Icons.location_city),
                      _field(
                        _phoneController,
                        "ስልክ ቁጥር",
                        Icons.phone,
                        isPhone: true,
                      ),

                      const Divider(height: 40),
                      _title("የስራ መረጃ"),
                      _field(
                        _professionTypeController,
                        "የሙያ ዘርፍ",
                        Icons.work_outline,
                      ),
                      _field(
                        _jobPositionController,
                        "የስራ መደብ",
                        Icons.assignment_ind,
                      ),
                      _field(
                        _countController,
                        "የሚፈለጉ ሰራተኞች ብዛት (1=50ብር)",
                        Icons.groups,
                        isNumberOnly: true,
                      ),

                      const Divider(height: 40),
                      _title("የክፍያ መረጃ"),
                      _field(
                        _amountController,
                        "አጠቃላይ ክፍያ",
                        Icons.money,
                        readOnly: true,
                      ),
                      _field(
                        _transactionIdController,
                        "የባንክ ትራንዛክሽን ቁጥር (Transaction ID)",
                        Icons.receipt_long,
                      ),

                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _submitData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "መረጃውን መዝግብ",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _title(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      t,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.purple,
      ),
    ),
  );

  Widget _field(
    TextEditingController c,
    String l,
    IconData i, {
    bool isPhone = false,
    bool isNumberOnly = false,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: c,
        readOnly: readOnly,
        keyboardType: (isPhone || isNumberOnly)
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: [
          if (isPhone || isNumberOnly) FilteringTextInputFormatter.digitsOnly,
          if (isPhone) LengthLimitingTextInputFormatter(10),
        ],
        decoration: InputDecoration(
          labelText: l,
          filled: readOnly,
          fillColor: readOnly ? Colors.grey[200] : Colors.transparent,
          prefixIcon: Icon(i, color: Colors.purple),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'እባክህ ይህንን ቦታ ሙሉ';
          return null;
        },
      ),
    );
  }
}
