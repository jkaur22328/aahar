import 'package:aahar/data/model/order.dart';
import 'package:aahar/features/auth/model/user_model.dart';
import 'package:aahar/features/auth/provider/auth_provider.dart';
import 'package:aahar/features/dashboard/provider/dashboard_provider.dart';
import 'package:aahar/util/routes.dart';
import 'package:aahar/util/utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardProvider dashboardProvider;
  late final AuthProvider authProvider;
  @override
  void initState() {
    dashboardProvider = DashboardProvider()..getAllOrders();
    authProvider = AuthProvider()
      ..getUserDetail(auth.FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  // Selected filter option
  String _selectedFilter = 'All';

  // Get filtered orders based on selected filter
  List<OrderModel> filteredOrders(List<OrderModel> orders) {
    if (_selectedFilter == 'All') {
      return orders;
    } else if (_selectedFilter == 'Pending') {
      return orders.where((order) => order.status == Status.pending).toList();
    } else if (_selectedFilter == 'Ongoing') {
      return orders.where((order) => order.status == Status.ongoing).toList();
    } else {
      return orders.where((order) => order.status == Status.completed).toList();
    }
  }

  // Get count of orders by status

  String _getInitials(String name) {
    return name[0];
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive layout
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Dashboard'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () {},
          // ),
          // IconButton(
          //   icon: const Icon(Icons.notifications_outlined),
          //   onPressed: () {},
          // ),
          // if (!isSmallScreen)
          ListenableBuilder(
              listenable: authProvider,
              builder: (context, _) {
                if (authProvider.loading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: CircleAvatar(
                      radius: 16,
                      child: Icon(Icons.person),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    context.go(Routes.profile,
                        extra: authProvider.currentUser!);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CircleAvatar(
                      radius: 16,
                      child: Text(
                        _getInitials(authProvider.currentUser!.name),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              }),
        ],
      ),
      floatingActionButton: ListenableBuilder(
          listenable: authProvider,
          builder: (context, _) {
            if (!authProvider.loading &&
                authProvider.currentUser != null &&
                authProvider.currentUser!.role == UserRole.admin) {
              return FloatingActionButton.extended(
                onPressed: () {
                  context.go(Routes.createOrder);
                },
                label: const Text('Add Order'),
                icon: const Icon(Icons.add),
              );
            }

            return const SizedBox();
          }),
      // drawer: isSmallScreen ? _buildDrawer() : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading with greeting
              Text(
                'Dashboard Overview',
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              Text(
                'Welcome back, check your order status',
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: isSmallScreen ? 16 : 24),

              // Order Summary Cards - Wrapped in a layout builder for responsiveness
              ListenableBuilder(
                  listenable: dashboardProvider,
                  builder: (context, _) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return isSmallScreen
                            ? _buildSummaryCardsGridView()
                            : _buildSummaryCardsRow();
                      },
                    );
                  }),

              SizedBox(height: isSmallScreen ? 16 : 24),

              // Filter Options
              _buildFilterSection(isSmallScreen),

              SizedBox(height: isSmallScreen ? 12 : 16),

              // Orders List
              ListenableBuilder(
                  listenable: dashboardProvider,
                  builder: (context, _) {
                    var orderList = filteredOrders(dashboardProvider.orders);
                    return orderList.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orderList.length,
                            itemBuilder: (context, index) {
                              final order = orderList[index];
                              return GestureDetector(
                                onTap: () {
                                  context.go(Routes.order, extra: {
                                    'order': order,
                                    'user': authProvider.currentUser!
                                  });
                                },
                                child: _buildOrderCard(order, isSmallScreen),
                              );
                            },
                          );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  // backgroundImage:
                  //     NetworkImage('https://via.placeholder.com/150'),
                  radius: 30,
                ),
                const SizedBox(height: 10),
                Text(
                  'Admin User',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'admin@example.com',
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            selected: true,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Orders'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Customers'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Products'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCardsGridView() {
    // For smaller screens - 2 column grid

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _buildSummaryCard('Total Orders', dashboardProvider.totalOrders,
            Colors.blue, Icons.shopping_bag_outlined),
        _buildSummaryCard('Pending', dashboardProvider.pendingOrders,
            Colors.orange, Icons.pending_outlined),
        _buildSummaryCard('Ongoing', dashboardProvider.ongoingOrders,
            Colors.purple, Icons.loop_outlined),
        _buildSummaryCard('Completed', dashboardProvider.completedOrders,
            Colors.green, Icons.check_circle_outlined),
      ],
    );
  }

  Widget _buildSummaryCardsRow() {
    // For larger screens - horizontal row
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Orders',
              dashboardProvider.totalOrders,
              Colors.blue,
              Icons.shopping_bag_outlined,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Pending',
              dashboardProvider.pendingOrders,
              Colors.orange,
              Icons.pending_outlined,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Ongoing',
              dashboardProvider.ongoingOrders,
              Colors.purple,
              Icons.loop_outlined,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Completed',
              dashboardProvider.completedOrders,
              Colors.green,
              Icons.check_circle_outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(bool isSmallScreen) {
    if (isSmallScreen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Orders',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All'),
                const SizedBox(width: 8),
                _buildFilterChip('Pending'),
                const SizedBox(width: 8),
                _buildFilterChip('Ongoing'),
                const SizedBox(width: 8),
                _buildFilterChip('Completed'),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Orders',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
          Row(
            children: [
              _buildFilterChip('All'),
              const SizedBox(width: 8),
              _buildFilterChip('Pending'),
              const SizedBox(width: 8),
              _buildFilterChip('Ongoing'),
              const SizedBox(width: 8),
              _buildFilterChip('Completed'),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildSummaryCard(
      String title, int count, Color color, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (title == 'Total Orders') {
          setState(() {
            _selectedFilter = 'All';
          });
        } else {
          setState(() {
            _selectedFilter = title;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: _selectedFilter == title ||
                  (title == 'Total Orders' && _selectedFilter == 'All')
              ? color.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 18,
              ),
            ),
            SizedBox(height: MediaQuery.sizeOf(context).width < 600 ? 10 : 20),
            Text(
              count.toString(),
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String title) {
    final isSelected = _selectedFilter == title;

    return FilterChip(
      selected: isSelected,
      label: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          color: isSelected ? Colors.blue : Colors.grey[700],
        ),
      ),
      onSelected: (selected) {
        setState(() {
          _selectedFilter = title;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected
              ? Colors.blue.withOpacity(0.5)
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      checkmarkColor: Colors.blue,
    );
  }

  Widget _buildOrderCard(OrderModel order, bool isSmallScreen) {
    Color statusColor = Colors.blue;
    String statusText = "";

    switch (order.status) {
      case Status.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case Status.ongoing:
        statusColor = Colors.purple;
        statusText = 'Ongoing';
        break;
      case Status.completed:
        statusColor = Colors.green;
        statusText = 'Completed';
        break;
    }

    if (isSmallScreen) {
      // Compact layout for small screens
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 12),
                  // Order details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderName,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Order #${order.id}',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: GoogleFonts.poppins(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey[200]),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMM dd, yyyy').format(order.addedDate.toDate()),
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      // Regular layout for larger screens
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Customer avatar

              const SizedBox(width: 16),
              // Order details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderName,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.primaries[
                            order.id.hashCode % Colors.primaries.length],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Order #${order.id}',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          DateFormat('MMM dd, yyyy')
                              .format(order.addedDate.toDate()),
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Order amount and status
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.poppins(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
