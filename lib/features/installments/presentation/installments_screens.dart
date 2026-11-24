// ignore_for_file: unused_import, unused_field, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../data/mock_installments_api.dart';

// ═══════════════════════════════════════════════════════════════════════════
// 1. Contracts List Screen
// ═══════════════════════════════════════════════════════════════════════════

class ContractsListScreen extends StatefulWidget {
  const ContractsListScreen({super.key});

  @override
  State<ContractsListScreen> createState() => _ContractsListScreenState();
}

class _ContractsListScreenState extends State<ContractsListScreen>
    with SingleTickerProviderStateMixin {
  final _api = MockInstallmentsApi();
  late TabController _tabController;
  List<Map<String, dynamic>> _contracts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadContracts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadContracts() async {
    setState(() => _isLoading = true);
    try {
      final stats = await _api.getStatistics();
      // In real app, fetch actual contracts
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.receipt_long, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            const Text(
              'عقود الأقساط',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerSearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: _loadContracts,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.goldenNeon,
          labelColor: AppColors.goldenNeon,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'نشط'),
            Tab(text: 'مكتمل'),
            Tab(text: 'متأخر'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildContractsList('active'),
                _buildContractsList('completed'),
                _buildContractsList('overdue'),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CustomerSearchScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.black),
        label: const Text(
          'عقد جديد',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildContractsList(String type) {
    // Mock data for demonstration
    final mockContracts = List.generate(5, (index) {
      return {
        'id': 'cont_00$index',
        'customer_name': 'عميل $index',
        'total_amount': 100000.0,
        'remaining_amount': 50000.0 - (index * 10000),
        'monthly_installment': 5000.0,
        'next_payment_date': DateTime.now().add(Duration(days: 30 - index)),
      };
    });

    if (mockContracts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد عقود',
              style: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
      itemCount: mockContracts.length,
      itemBuilder: (context, index) {
        final contract = mockContracts[index];
        return _buildContractCard(contract);
      },
    );
  }

  Widget _buildContractCard(Map<String, dynamic> contract) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.card, AppColors.background],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ContractDetailsScreen(contractId: contract['id']),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contract['customer_name'],
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'عقد #${contract['id']}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.successDark.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'نشط',
                      style: TextStyle(
                        color: AppColors.successLight,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: AppColors.border),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'المتبقي',
                      '${contract['remaining_amount']} ج.م',
                      AppColors.warningDark,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'القسط الشهري',
                      '${contract['monthly_installment']} ج.م',
                      AppColors.infoDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 2. Contract Details Screen
// ═══════════════════════════════════════════════════════════════════════════

class ContractDetailsScreen extends StatefulWidget {
  final String contractId;

  const ContractDetailsScreen({super.key, required this.contractId});

  @override
  State<ContractDetailsScreen> createState() => _ContractDetailsScreenState();
}

class _ContractDetailsScreenState extends State<ContractDetailsScreen> {
  final _api = MockInstallmentsApi();
  Map<String, dynamic>? _contract;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContract();
  }

  Future<void> _loadContract() async {
    setState(() => _isLoading = true);
    try {
      final result = await _api.getContract(widget.contractId);
      if (result['success'] && mounted) {
        setState(() {
          _contract = result['data'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: Text(
          'عقد #${widget.contractId}',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : isMobile
          ? _buildMobileLayout()
          : _buildTabletLayout(),
      floatingActionButton:
          _contract != null && (_contract!['remaining_amount'] as double) > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RecordPaymentScreen(
                      contractId: widget.contractId,
                      remainingAmount: _contract!['remaining_amount'],
                    ),
                  ),
                ).then((_) => _loadContract());
              },
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.payment, color: AppColors.black),
              label: const Text(
                'تسجيل دفعة',
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildContractInfoCard(),
          const SizedBox(height: 16),
          _buildPaymentScheduleCard(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
            child: _buildContractInfoCard(),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
            child: _buildPaymentScheduleCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildContractInfoCard() {
    if (_contract == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long, color: AppColors.goldenNeon),
              SizedBox(width: 12),
              Text(
                'معلومات العقد',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 16),
          _buildInfoRow('المبلغ الإجمالي', '${_contract!['total_amount']} ج.م'),
          const SizedBox(height: 12),
          _buildInfoRow('المقدم', '${_contract!['down_payment']} ج.م'),
          const SizedBox(height: 12),
          _buildInfoRow(
            'المتبقي',
            '${_contract!['remaining_amount']} ج.م',
            valueColor: AppColors.warningDark,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'القسط الشهري',
            '${_contract!['monthly_installment']} ج.م',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'عدد الأقساط',
            '${_contract!['installments_count']} قسط',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'الأقساط المدفوعة',
            '${_contract!['paid_installments']} قسط',
            valueColor: AppColors.successDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.goldenNeon.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month, color: AppColors.goldenNeon),
              SizedBox(width: 12),
              Text(
                'جدول الأقساط',
                style: TextStyle(
                  color: AppColors.goldenNeon,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 16),
          const Text(
            'سيتم عرض جدول الأقساط هنا',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 3. Record Payment Screen
// ═══════════════════════════════════════════════════════════════════════════

class RecordPaymentScreen extends StatefulWidget {
  final String contractId;
  final double remainingAmount;

  const RecordPaymentScreen({
    super.key,
    required this.contractId,
    required this.remainingAmount,
  });

  @override
  State<RecordPaymentScreen> createState() => _RecordPaymentScreenState();
}

class _RecordPaymentScreenState extends State<RecordPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _api = MockInstallmentsApi();
  String _selectedMethod = 'cash';
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.remainingAmount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _recordPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      await _api.recordPayment(
        contractId: widget.contractId,
        amount: double.parse(_amountController.text),
        method: _selectedMethod,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الدفعة بنجاح'),
            backgroundColor: AppColors.successDark,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل تسجيل الدفعة: $e'),
            backgroundColor: AppColors.errorDark,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: const Text(
          'تسجيل دفعة',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: AppColors.textPrimary),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  labelText: 'المبلغ (ج.م)',
                  hintText: widget.remainingAmount.toStringAsFixed(2),
                  prefixIcon: const Icon(
                    Icons.payments,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'الرجاء إدخال المبلغ';
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) return 'المبلغ غير صحيح';
                  if (amount > widget.remainingAmount) {
                    return 'المبلغ أكبر من المتبقي';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Payment Method
              DropdownButtonFormField<String>(
                value: _selectedMethod,
                style: const TextStyle(color: AppColors.textPrimary),
                dropdownColor: AppColors.card,
                decoration: InputDecoration(
                  labelText: 'طريقة الدفع',
                  prefixIcon: const Icon(
                    Icons.credit_card,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'cash', child: Text('نقدي')),
                  DropdownMenuItem(value: 'card', child: Text('بطاقة')),
                  DropdownMenuItem(value: 'transfer', child: Text('تحويل')),
                  DropdownMenuItem(value: 'check', child: Text('شيك')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _selectedMethod = value);
                },
              ),

              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'ملاحظات (اختياري)',
                  hintText: 'أضف أي ملاحظات...',
                  prefixIcon: const Icon(Icons.note, color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _isProcessing ? null : _recordPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.black,
                        ),
                      )
                    : const Text(
                        'تسجيل الدفعة',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 4. Customer Search Screen
// ═══════════════════════════════════════════════════════════════════════════

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  final _searchController = TextEditingController();
  final _api = MockInstallmentsApi();
  List<Map<String, dynamic>> _customers = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isSearching = true);

    try {
      final result = await _api.searchCustomer(name: query);
      if (result['success'] && mounted) {
        setState(() {
          _customers = List<Map<String, dynamic>>.from(
            result['data']['customers'],
          );
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: const Text(
          'البحث عن عميل',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'ابحث بالاسم أو الهاتف أو الرقم القومي',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          if (_isSearching)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_customers.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_search,
                      size: 64,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'ابحث عن عميل',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
                itemCount: _customers.length,
                itemBuilder: (context, index) {
                  final customer = _customers[index];
                  return _buildCustomerCard(customer);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateCustomerScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: AppColors.black),
        label: const Text(
          'عميل جديد',
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.goldenNeon.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, color: AppColors.black),
        ),
        title: Text(
          customer['name'],
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          customer['phone'],
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textSecondary,
          size: 16,
        ),
        onTap: () {
          // Navigate to create contract
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// 5. Create Customer Screen
// ═══════════════════════════════════════════════════════════════════════════

class CreateCustomerScreen extends StatefulWidget {
  const CreateCustomerScreen({super.key});

  @override
  State<CreateCustomerScreen> createState() => _CreateCustomerScreenState();
}

class _CreateCustomerScreenState extends State<CreateCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _addressController = TextEditingController();
  final _api = MockInstallmentsApi();
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _createCustomer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      await _api.createCustomer(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        address: _addressController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إنشاء العميل بنجاح'),
            backgroundColor: AppColors.successDark,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل إنشاء العميل: $e'),
            backgroundColor: AppColors.errorDark,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.card,
        title: const Text(
          'عميل جديد',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context)),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'الاسم *',
                  prefixIcon: const Icon(
                    Icons.person,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'الرجاء إدخال الاسم';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف *',
                  prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال رقم الهاتف';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nationalIdController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: AppColors.textPrimary),
                maxLength: 14,
                decoration: InputDecoration(
                  labelText: 'الرقم القومي *',
                  prefixIcon: const Icon(
                    Icons.badge_outlined,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال الرقم القومي';
                  }
                  if (value.length != 14)
                    return 'الرقم القومي يجب أن يكون 14 رقم';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'العنوان *',
                  prefixIcon: const Icon(
                    Icons.location_on,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: AppColors.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'الرجاء إدخال العنوان';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isProcessing ? null : _createCustomer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.black,
                        ),
                      )
                    : const Text(
                        'إنشاء العميل',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
