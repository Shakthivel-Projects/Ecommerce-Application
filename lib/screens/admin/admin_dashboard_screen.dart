import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn || auth.user == null || !auth.user!.isAdmin) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Admin access only',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${auth.user!.name}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'Admin actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                title: const Text('Manage products'),
                subtitle: const Text('Create, update, or delete products'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product management not implemented yet'),
                    ),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('View all orders'),
                subtitle: const Text('See and manage customer orders'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Admin orders view not implemented yet'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
