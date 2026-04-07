import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ------------------------------------------------------------------------
// BENEFICIARY MODEL
// ------------------------------------------------------------------------
class BeneficiaryModel {
  final String id;
  final String name;
  final String bankName;
  final String accountNo;
  final String ifsc;

  BeneficiaryModel({
    required this.id,
    required this.name,
    required this.bankName,
    required this.accountNo,
    required this.ifsc,
  });
}

// ------------------------------------------------------------------------
// MAIN MONEY TRANSFER SCREEN
// ------------------------------------------------------------------------
class MoneyTransferScreen extends StatefulWidget {
  const MoneyTransferScreen({Key? key}) : super(key: key);

  @override
  State<MoneyTransferScreen> createState() => _MoneyTransferScreenState();
}

class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
  // 0: Search Mobile, 1: Beneficiary List, 2: Transfer Amount
  int _currentStep = 0;

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _senderName = "";
  BeneficiaryModel? _selectedBeneficiary;
  String _transferMode = "IMPS"; // IMPS or NEFT

  // Dummy Beneficiary Data
  final List<BeneficiaryModel> _dummyBeneficiaries = [
    BeneficiaryModel(id: "BEN001", name: "Ramesh Kumar", bankName: "State Bank of India", accountNo: "3102XXXXXX9876", ifsc: "SBIN0001234"),
    BeneficiaryModel(id: "BEN002", name: "Suresh Singh", bankName: "HDFC Bank", accountNo: "5010XXXXXX3421", ifsc: "HDFC0004567"),
    BeneficiaryModel(id: "BEN003", name: "Pooja Sharma", bankName: "ICICI Bank", accountNo: "0001XXXXXX8890", ifsc: "ICIC0000001"),
  ];

  // Helper for Date Formatting (No external packages needed)
  String _getCurrentFormattedDate() {
    final now = DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    String day = now.day.toString().padLeft(2, '0');
    String month = months[now.month - 1];
    String year = now.year.toString();

    int hour = now.hour;
    String ampm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour;
    String min = now.minute.toString().padLeft(2, '0');

    return '$day $month $year, $hour:$min $ampm';
  }

  void _verifyMobile() {
    if (_mobileController.text.length == 10) {
      FocusScope.of(context).unfocus();
      setState(() {
        _senderName = "Rahul Verma"; // Dummy Sender Name
        _currentStep = 1; // Move to Beneficiary List
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid 10-digit mobile number"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _selectBeneficiary(BeneficiaryModel ben) {
    setState(() {
      _selectedBeneficiary = ben;
      _currentStep = 2; // Move to Amount Entry
    });
  }

  void _goBack() {
    FocusScope.of(context).unfocus();
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
        if (_currentStep == 1) {
          _amountController.clear();
        }
      } else {
        Navigator.pop(context);
      }
    });
  }

  // ------------------------------------------------------------------------
  // RASID (RECEIPT) DIALOG - Sleek and Safe
  // ------------------------------------------------------------------------
  void _showTransferRasid() {
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: 1.0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF006400), width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF006400), size: 48),
                  const SizedBox(height: 10),
                  const Text(
                    "Transfer Successful",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006400),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Mode: $_transferMode",
                    style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                  const Divider(thickness: 1, color: Colors.grey, height: 24),
                  _rasidRow("Beneficiary", _selectedBeneficiary!.name),
                  _rasidRow("Account No", _selectedBeneficiary!.accountNo),
                  _rasidRow("Bank", _selectedBeneficiary!.bankName),
                  _rasidRow("Date", _getCurrentFormattedDate()),
                  _rasidRow("Txn ID", "DMT${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}"),
                  _rasidRow("Bank RRN", "987654321098"),
                  const SizedBox(height: 16),

                  // Amount Box
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FFE6), // Light Lemon Tint
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFDFFF00).withOpacity(0.5)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Transferred", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF006400))),
                        Text("₹${_amountController.text}.00", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF006400))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDFFF00), // Lemon Yellow
                        foregroundColor: Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back to dashboard/previous screen
                      },
                      child: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _rasidRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 13)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------------
  // UI BUILDERS FOR EACH STEP
  // ------------------------------------------------------------------------

  // STEP 0: Enter Mobile Number
  Widget _buildStep0MobileSearch() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Sender Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          const Text("Enter customer mobile number to search or register sender.", style: TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _mobileController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 1.2),
              decoration: const InputDecoration(
                counterText: "",
                prefixIcon: Icon(Icons.phone_android_rounded, color: Color(0xFF006400)),
                hintText: "10-Digit Mobile Number",
                hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: 0),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF006400), // Forest Green
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: _verifyMobile,
              child: const Text("Verify & Proceed", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  // STEP 1: Beneficiary List
  Widget _buildStep1BeneficiaryList() {
    return Column(
      children: [
        // Sender Info Card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Sender Name", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(_senderName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Mobile Number", style: TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text("+91 ${_mobileController.text}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Beneficiary List Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Saved Beneficiaries", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
              TextButton.icon(
                onPressed: () {}, // Future logic to add new bene
                icon: const Icon(Icons.add_circle_outline, size: 16, color: Color(0xFF006400)),
                label: const Text("Add New", style: TextStyle(color: Color(0xFF006400), fontWeight: FontWeight.w600, fontSize: 13)),
              )
            ],
          ),
        ),

        // Beneficiary List
        Expanded(
          child: ListView.builder(
            physics: const ClampingScrollPhysics(), // Sleek scrolling, no bounce
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: _dummyBeneficiaries.length,
            itemBuilder: (context, index) {
              final ben = _dummyBeneficiaries[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _selectBeneficiary(ben),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FFE6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(child: Icon(Icons.account_balance, color: Color(0xFF006400))),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ben.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87)),
                              const SizedBox(height: 4),
                              Text("${ben.bankName} • ${ben.accountNo}", style: const TextStyle(color: Colors.black54, fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // STEP 2: Transfer Form (Amount & Mode)
  Widget _buildStep2TransferForm() {
    if (_selectedBeneficiary == null) return const SizedBox();

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected Beneficiary Details
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF006400).withOpacity(0.3)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Transfer To", style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(_selectedBeneficiary!.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text("A/c: ${_selectedBeneficiary!.accountNo}", style: const TextStyle(fontSize: 13, color: Colors.black54)),
                Text("IFSC: ${_selectedBeneficiary!.ifsc} • ${_selectedBeneficiary!.bankName}", style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Transfer Mode Selection (IMPS / NEFT)
          const Text("Transfer Mode", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _transferMode = "IMPS"),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _transferMode == "IMPS" ? const Color(0xFF006400) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _transferMode == "IMPS" ? const Color(0xFF006400) : Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        "IMPS (Instant)",
                        style: TextStyle(
                            color: _transferMode == "IMPS" ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600, fontSize: 13
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _transferMode = "NEFT"),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _transferMode == "NEFT" ? const Color(0xFF006400) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _transferMode == "NEFT" ? const Color(0xFF006400) : Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        "NEFT (2-4 Hrs)",
                        style: TextStyle(
                            color: _transferMode == "NEFT" ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600, fontSize: 13
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Amount Input
          const Text("Enter Amount (₹)", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF006400)),
              decoration: const InputDecoration(
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: Text("₹", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54)),
                ),
                prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                hintText: "0.00",
                hintStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Transfer Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDFFF00), // Lemon Yellow
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                if (_amountController.text.isNotEmpty && int.tryParse(_amountController.text) != null && int.parse(_amountController.text) > 0) {
                  _showTransferRasid();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid amount")));
                }
              },
              child: const Text("Send Money", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------------
  // MAIN UI BUILD
  // ------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4), // Premium Light Grey/Green tint background
      appBar: AppBar(
        backgroundColor: const Color(0xFF006400), // Forest Green
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: _goBack,
        ),
        title: const Text("Money Transfer", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
        actions: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Step ${_currentStep + 1} of 3",
                style: const TextStyle(color: Color(0xFFDFFF00), fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: IndexedStack(
          index: _currentStep, // Smoothly switches between screens without UI jump
          children: [
            _buildStep0MobileSearch(),
            _buildStep1BeneficiaryList(),
            _buildStep2TransferForm(),
          ],
        ),
      ),
    );
  }
}