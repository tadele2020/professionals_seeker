import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobSeekerForm extends StatefulWidget {
  const JobSeekerForm({super.key});

  @override
  State<JobSeekerForm> createState() => _JobSeekerFormState();
}

class _JobSeekerFormState extends State<JobSeekerForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _otherPositionController = TextEditingController();
  final _amountController = TextEditingController(); // አዲስ
  final _transactionIdController = TextEditingController(); // አዲስ

  String _workStatus = 'Unemployed';
  String? _selectedPosition;
  final List<String> _selectedProfessions = [];
  bool _isLoading = false;

  // የ Google Apps Script URL (የመጀመሪያው በ /exec የሚያልቀው መሆኑን አረጋግጥ)
  final String googleSheetUrl =
      "https://script.google.com/macros/s/AKfycbwXdWKXE32R25vVMHCvZKymgXi9lFST0lLChnxVN_iuUNvI1LFSUQWL4a2_-C8dxbI0/exec";

  final List<String> _positionOptions = [
    'ቴክኒካል ማናጀር',
    'ስቶር ማናጀር',
    'ስቶር ረዳት',
    'ሚድ ዋይፍ',
    'አካውነታነት',
    'ሴልስ',
    'በተገኘው የሥራ ክፍል',
    'ከዚህ ሌላ',
  ];

  final List<String> _professionsList = [
    'Doctor (ሀኪም)',
    'Nurse (ነርስ)',
    'Pharmacist (ፋርማሲስት)',
    'Lab Technician (ላብራቶሪ)',
    'Health Officer',
    'Radiology',
    'Anesthesia',
    'Midwifery',
    'Dental',
    'Environmental Health',
    'Optometry',
    'Psychology',
    'Physiotherapy',
    'Anatomy',
    'Physiology',
    'Biomedical Engineering',
    'Other',
  ];

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProfessions.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('እባክዎ ቢያንስ አንድ ሙያ ይምረጡ!')));
      return;
    }
    if (_selectedPosition == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('እባክዎ የሥራ መደብ ይምረጡ!')));
      return;
    }

    setState(() => _isLoading = true);
    String finalPos = _selectedPosition == 'ከዚህ ሌላ'
        ? _otherPositionController.text.trim()
        : _selectedPosition!;

    // ለሁለቱም የሚላክ ዳታ ዝግጅት
    final Map<String, dynamic> formData = {
      'fullName': _nameController.text.trim(),
      'phoneNumber': _phoneController.text.trim(),
      'city': _cityController.text.trim(),
      'professions': _selectedProfessions.join(", "),
      'position': finalPos,
      'workStatus': _workStatus == 'Unemployed' ? 'ሥራ ፈላጊ' : 'ሥራ ላይ ያለ',
      'amountPaid': _amountController.text.trim(), // አዲስ
      'transactionId': _transactionIdController.text.trim(), // አዲስ
    };

    try {
      // 1. ወደ Firebase መላክ
      await FirebaseFirestore.instance.collection('job_seekers').add({
        ...formData,
        'professions': _selectedProfessions,
        'submittedAt': FieldValue.serverTimestamp(),
      });

      // 2. ወደ Google Sheet መላክ
      try {
        final response = await http.post(
          Uri.parse(googleSheetUrl),
          headers: {"Content-Type": "application/json"},
          body: json.encode(formData),
        );

        if (response.statusCode == 200 || response.statusCode == 302) {
          debugPrint("መረጃው በትክክል ወደ Google Sheet ተልኳል!");
        } else {
          debugPrint("የGoogle Sheet ስህተት፦ ${response.statusCode}");
        }
      } catch (e) {
        debugPrint("ወደ Google Sheet በመላክ ላይ ስህተት፦ $e");
      }

      _showSuccess();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle, color: Colors.purple, size: 70),
        content: const Text('መረጃዎ በትክክል ተመዝግቧል!', textAlign: TextAlign.center),
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
        title: const Text('የሥራ ፈላጊ መመዝገቢያ'),
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
              _title('የግል መረጃ'),
              _field(_nameController, 'ሙሉ ስም', Icons.person),
              _field(_phoneController, 'ስልክ ቁጥር', Icons.phone, isPhone: true),
              _field(_cityController, 'ከተማ', Icons.location_city),

              const SizedBox(height: 20),
              _title('የሙያ ዘርፍ'),
              Wrap(
                spacing: 8,
                children: _professionsList
                    .map(
                      (p) => FilterChip(
                        label: Text(p),
                        selected: _selectedProfessions.contains(p),
                        onSelected: (v) => setState(
                          () => v
                              ? _selectedProfessions.add(p)
                              : _selectedProfessions.remove(p),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 25),
              _title('የሥራ መደብ (Position) የትኛውን የሥራ መደብ ይፈልጋሉ?'),
              DropdownButtonFormField<String>(
                initialValue: _selectedPosition,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.work, color: Colors.purple),
                ),
                items: _positionOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedPosition = v),
                validator: (v) => v == null ? 'እባክዎ ይምረጡ' : null,
              ),
              if (_selectedPosition == 'ከዚህ ሌላ') ...[
                const SizedBox(height: 10),
                _field(
                  _otherPositionController,
                  'የሥራ መደቡን እዚህ ይጻፉ',
                  Icons.edit,
                ),
              ],

              const SizedBox(height: 25),
              _title('የሥራ ሁኔታ'),
              RadioListTile(
                title: const Text('ሥራ ፈላጊ'),
                value: 'Unemployed',
                groupValue: _workStatus,
                onChanged: (v) => setState(() => _workStatus = v.toString()),
                activeColor: Colors.purple,
              ),
              RadioListTile(
                title: const Text('ሥራ ላይ ያለ'),
                value: 'Employed',
                groupValue: _workStatus,
                onChanged: (v) => setState(() => _workStatus = v.toString()),
                activeColor: Colors.purple,
              ),

              const SizedBox(height: 20),
              _title('የክፍያ መረጃ (CBE) 50 Birr'),
              _field(
                _amountController,
                'የተላከ ብር መጠን',
                Icons.money,
                isNumberOnly: true,
              ),
              _field(
                _transactionIdController,
                'Transaction ID NO of CBE',
                Icons.receipt_long,
              ),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: c,
        keyboardType: (isPhone || isNumberOnly)
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: [
          if (isPhone || isNumberOnly) FilteringTextInputFormatter.digitsOnly,
          if (isPhone) LengthLimitingTextInputFormatter(10),
        ],
        decoration: InputDecoration(
          labelText: l,
          prefixIcon: Icon(i, color: Colors.purple),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return 'እባክዎ $l ያስገቡ';
          if (isPhone && (!v.startsWith('09') || v.length != 10))
            return 'ትክክለኛ ስልክ (09...) ያስገቡ';
          return null;
        },
      ),
    );
  }
}
