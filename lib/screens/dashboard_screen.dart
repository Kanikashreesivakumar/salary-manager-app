import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/expense_card.dart';
import 'add_expense_screen.dart';
import 'salary_screen.dart';
import 'login_screen.dart';
import 'summary_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = true;
  String _searchQuery = "";
  String _selectedFilter = "All";
  final List<String> _filters = ["All", "Shopping", "Food", "Transport", "Bills", "Other"];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await Future.wait([
      StorageService.fetchSalary(),
      StorageService.fetchExpenses(),
    ]);
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = StorageService.expenses.where((e) {
      final matchesSearch = e.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter = _selectedFilter == "All" || e.title.startsWith(_selectedFilter);
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      drawer: _buildDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1A237E),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Total Balance", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    const SizedBox(height: 10),
                    Text(
                      "₹ ${StorageService.getBalance().toStringAsFixed(2)}",
                      style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics_outlined, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SummaryScreen())),
              ),
            ],
          ),
          
          // QUICK ACTIONS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(child: _QuickActionCard(title: "Salary", subtitle: "Add Income", icon: Icons.account_balance_wallet, color: Colors.green, onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaryScreen())); _loadData(); })),
                  const SizedBox(width: 15),
                  Expanded(child: _QuickActionCard(title: "Expense", subtitle: "Add Spend", icon: Icons.shopping_cart, color: Colors.orange, onTap: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseScreen())); _loadData(); })),
                ],
              ),
            ),
          ),

          // SEARCH & FILTERS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: "Search transactions...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _filters.length,
                      itemBuilder: (context, i) {
                        final filter = _filters[i];
                        final isSelected = _selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FilterChip(
                            label: Text(filter),
                            selected: isSelected,
                            onSelected: (v) => setState(() => _selectedFilter = filter),
                            selectedColor: Colors.indigo.withOpacity(0.2),
                            checkmarkColor: Colors.indigo,
                            labelStyle: TextStyle(color: isSelected ? Colors.indigo : Colors.black54, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              child: Text("Recent Transactions (${filteredExpenses.length})", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),

          _isLoading
              ? const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
              : filteredExpenses.isEmpty
                  ? SliverFillRemaining(child: Center(child: Text("No transactions found", style: TextStyle(color: Colors.grey[500]))))
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final e = filteredExpenses[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ExpenseCard(expense: e, onDelete: () async { if (e.id != null) { await StorageService.deleteExpense(e.id!); _loadData(); } }),
                            );
                          },
                          childCount: filteredExpenses.length,
                        ),
                      ),
                    ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1A237E)),
            accountName: const Text("Kani User", style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: const Text("user@example.com"),
            currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, size: 40, color: Color(0xFF1A237E))),
          ),
          ListTile(leading: const Icon(Icons.home), title: const Text("Home"), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.bar_chart), title: const Text("Analytics"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SummaryScreen()))),
          ListTile(leading: const Icon(Icons.savings), title: const Text("Savings Goals"), onTap: () {}),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await StorageService.logout();
              if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (r) => false);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color)),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }
}