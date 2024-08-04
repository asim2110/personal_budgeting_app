import 'package:flutter/material.dart';
import 'package:personal_budgeting_app/Views/add_budget_category_screen.dart';
import 'package:personal_budgeting_app/Views/budget_category_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Categories')),
      body: const BudgetCategoryList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditBudgetCategoryScreen(),
            ),
          );
        },
        label: const Text('Budget Categore'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
