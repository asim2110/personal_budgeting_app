import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEditBudgetCategoryScreen extends StatefulWidget {
  final DocumentSnapshot? category;

  const AddEditBudgetCategoryScreen({super.key, this.category});

  @override
  // ignore: library_private_types_in_public_api
  _AddEditBudgetCategoryScreenState createState() =>
      _AddEditBudgetCategoryScreenState();
}

class _AddEditBudgetCategoryScreenState
    extends State<AddEditBudgetCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _budgetedController;
  double spentAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.category?.get('name') ?? '');
    _budgetedController = TextEditingController(
        text: widget.category?.get('budgeted')?.toString() ?? '');
    if (widget.category != null) {
      spentAmount = widget.category!.get('spent') ?? 0.0;
    }
  }

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.category == null) {
          await FirebaseFirestore.instance.collection('categories').add({
            'name': _nameController.text,
            'budgeted': double.parse(_budgetedController.text),
            'pent': 0.0,
          });
        } else {
          await widget.category!.reference.update({
            'name': _nameController.text,
            'budgeted': double.parse(_budgetedController.text),
          });
        }
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving category: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double budgeted = double.tryParse(_budgetedController.text) ?? 0.0;
    double remaining = budgeted - spentAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _budgetedController,
                decoration: InputDecoration(
                  labelText: 'Budgeted Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a budgeted amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Spent Amount: \$${spentAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                'Remaining Budget: \$${remaining.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _budgetedController.dispose();
    super.dispose();
  }
}
