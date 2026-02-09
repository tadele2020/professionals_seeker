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
      "https://script.google.com/macros/s/AKfycbwR3QTIALbpeL6H01ZdLdmxBNUFq13_RcQqsjZWJbFgtt2HTko1dodNUXCaT3Ym-70/exec";

  @override
  void initState() {
    super.initState();
    // ብዛት ሲገባ ብር በራስ-ሰር እንዲሰላ
    _countController.addListener(_calculateAmount);
  }

  void _calculateAmount() {
    final count = int.tryParse(_countController.text) ?? 0;
    if (count > 0) {
      _amountController.text = (count * 50).toString();
    } else {
      _amountController.text = "";
    }
  }

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  Future<void> _submitEmployerForm() async {
    if (!_formKey.currentState!.validate()) return;

    // የክፍያ ማረጋገጫ ሎጂክ
    final count = int.tryParse(_countController.text) ?? 0;
    final amountPaid = int.tryParse(_amountController.text) ?? 0;
    final expectedAmount = count * 50;

    if (amountPaid < expectedAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('ስህተት፡ ለ $count ባለሙያ $expectedAmount ብር መክፈል አለብዎት!'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final Map<String, dynamic> employerData = {
      'organizationName': _orgNameController.text.trim(),
      'city': _cityController.text.trim(),
      'phoneNumber': _phoneController.text.trim(),
      'professionNeeded': _professionTypeController.text.trim(),
      'jobPosition': _jobPositionController.text.trim(),
      'professionalCount': _countController.text.trim(),
      'amountPaid': _amountController.text.trim(),
      'transactionId': _transactionIdController.text.trim(),
    };

    try {
      await FirebaseFirestore.instance.collection('employers').add({
        ...employerData,
        'submittedAt': FieldValue.serverTimestamp(),
      });

      try {
        await http.post(
          Uri.parse(googleSheetUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(employerData),
        );
      } catch (e) {
        debugPrint("Google Sheet error: $e");
      }

      setState(() => _isLoading = false);
      _showSuccessDialog();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('ስህተት ተፈጥሯል: $e')));
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.purple, size: 70),
        content: const Text(
          'የቀጣሪ መረጃዎ በትክክል ተመዝግቧል!',
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              child: const Text('እሺ', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('የቀጣሪዎች መመዝገቢያ', style: GoogleFonts.notoSansEthiopic()),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('የድርጅት መረጃ'),
              _buildField(
                _orgNameController,
                'የባለሙያ ፈላጊ ድርጅት ሥም',
                Icons.business,
              ),
              _buildField(_cityController, 'አድራሻ (ከተማ)', Icons.location_on),
              _buildField(
                _phoneController,
                'ስልክ ቁጥር',
                Icons.phone,
                isPhone: true,
              ),

              const SizedBox(height: 20),
              _sectionTitle('የፍላጎት ዝርዝር'),
              _buildField(
                _professionTypeController,
                'የሚፈልገው ባለሙያ ዓይነት',
                Icons.person_search,
              ),
              _buildField(_jobPositionController, 'በየትኛው የስራ መደብ?', Icons.work),
              _buildField(
                _countController,
                'የሚፈልገው ባለሙያ ብዛት',
                Icons.group,
                isNumberOnly: true,
              ),

              const SizedBox(height: 20),
              _sectionTitle('የክፍያ መረጃ (CBE) - 1 ሰው 50 ብር'),
              _buildField(
                _amountController,
                'መከፈል ያለበት ብር',
                Icons.money,
                isNumberOnly: true,
                readOnly: true,
              ),
              _buildField(
                _transactionIdController,
                'Transaction ID NO of CBE',
                Icons.receipt_long,
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitEmployerForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'መረጃውን ላክ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
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

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isPhone = false,
    bool isNumberOnly = false,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        // ስልክ ወይም ቁጥር ከሆነ የቁጥር ኪቦርድ ብቻ እንዲመጣ
        keyboardType: (isPhone || isNumberOnly)
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: [
          // ስልክ ወይም ቁጥር ከሆነ ቁጥር ብቻ እንዲቀበል
          if (isPhone || isNumberOnly) FilteringTextInputFormatter.digitsOnly,
          // ስልክ ከሆነ ከ 10 ቁጥር በላይ እንዳይቀበል
          if (isPhone) LengthLimitingTextInputFormatter(10),
        ],
        decoration: InputDecoration(
          labelText: label,
          filled: readOnly,
          fillColor: readOnly ? Colors.grey[200] : Colors.transparent,
          prefixIcon: Icon(icon, color: Colors.purple),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.purple, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'እባክዎ ይህንን ቦታ ይሙሉ';
          }
          if (isPhone) {
            // ስልክ ቁጥሩ በ 09 ወይም በ 07 መጀመሩን ያረጋግጣል
            if (!value.startsWith('09') && !value.startsWith('07')) {
              return 'ስልክ ቁጥር በ 09 ወይም 07 መጀመር አለበት';
            }
            // ስልክ ቁጥሩ በትክክል 10 ዲጂት መሆኑን ያረጋግጣል
            if (value.length != 10) {
              return 'ስልክ ቁጥር 10 ዲጂት መሆን አለበት';
            }
          }
          return null;
        },
      ),
    );
  }
}
