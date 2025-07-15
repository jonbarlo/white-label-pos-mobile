import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:white_label_pos_mobile/src/features/pos/models/customer.dart';

class CustomerSelectionDialog extends ConsumerStatefulWidget {
  final String? initialCustomerName;
  final String? initialCustomerEmail;

  const CustomerSelectionDialog({
    super.key,
    this.initialCustomerName,
    this.initialCustomerEmail,
  });

  @override
  ConsumerState<CustomerSelectionDialog> createState() => _CustomerSelectionDialogState();
}

class _CustomerSelectionDialogState extends ConsumerState<CustomerSelectionDialog> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  List<Customer> _searchResults = [];
  bool _isSearching = false;
  bool _showNewCustomerForm = false;
  Customer? _selectedCustomer;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.initialCustomerName ?? '';
    _emailController.text = widget.initialCustomerEmail ?? '';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _searchCustomers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      // TODO: Implement customer search using customer repository
      // For now, we'll use mock data
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _searchResults = [
          const Customer(
            id: 1,
            name: 'John Doe',
            email: 'john@example.com',
            phone: '+1234567890',
            businessId: 1,
          ),
          const Customer(
            id: 2,
            name: 'Jane Smith',
            email: 'jane@example.com',
            phone: '+1234567891',
            businessId: 1,
          ),
        ].where((customer) =>
          customer.name.toLowerCase().contains(query.toLowerCase()) ||
          (customer.email?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (customer.phone?.contains(query) ?? false)
        ).toList();
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching customers: $e')),
        );
      }
    }
  }

  void _selectCustomer(Customer customer) {
    setState(() {
      _selectedCustomer = customer;
      _showNewCustomerForm = false;
    });
  }

  void _toggleNewCustomerForm() {
    setState(() {
      _showNewCustomerForm = true;
      _selectedCustomer = null;
    });
  }

  void _continueAsGuest() {
    Navigator.of(context).pop({
      'customerId': null,
      'customerName': 'Guest',
      'customerEmail': 'guest@pos.com',
    });
  }

  void _confirmSelection() {
    if (_selectedCustomer != null) {
      Navigator.of(context).pop({
        'customerId': _selectedCustomer!.id,
        'customerName': _selectedCustomer!.name,
        'customerEmail': _selectedCustomer!.email,
      });
    } else if (_showNewCustomerForm) {
      // TODO: Create new customer using customer repository
      Navigator.of(context).pop({
        'customerId': null, // Will be created on backend
        'customerName': _nameController.text.trim(),
        'customerEmail': _emailController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Customer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search customers by name, email, or phone...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                _searchCustomers(value);
              },
            ),
            const SizedBox(height: 10),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _toggleNewCustomerForm,
                    icon: const Icon(Icons.person_add),
                    label: const Text('New Customer'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _continueAsGuest,
                    icon: const Icon(Icons.person_off),
                    label: const Text('Guest Checkout'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Search Results or New Customer Form
            if (_showNewCustomerForm) ...[
              const Text(
                'New Customer',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ] else if (_searchResults.isNotEmpty) ...[
              const Text(
                'Search Results',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final customer = _searchResults[index];
                    final isSelected = _selectedCustomer?.id == customer.id;
                    
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(customer.name[0].toUpperCase()),
                      ),
                      title: Text(customer.name),
                      subtitle: Text('${customer.email ?? 'No email'}\n${customer.phone ?? 'No phone'}'),
                      selected: isSelected,
                      onTap: () => _selectCustomer(customer),
                    );
                  },
                ),
              ),
            ] else if (_searchController.text.isNotEmpty && !_isSearching) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No customers found'),
                ),
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_selectedCustomer != null || _showNewCustomerForm) 
                    ? () => _confirmSelection() 
                    : null,
                child: Text(_showNewCustomerForm ? 'Create Customer' : 'Select Customer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 