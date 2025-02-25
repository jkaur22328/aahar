import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Sample data - in real app would come from backend
  final Map<String, int> metrics = {
    'Total Orders': 156,
    'Pending': 23,
    'Ongoing': 45,
    'Completed': 88,
  };

  final Map<String, List<Map<String, dynamic>>> roleStatuses = {
    'Shopping': [
      {
        'location': 'Central Market',
        'status': 'Ongoing',
        'eta': '30 mins',
        'items': 45,
      },
      {
        'location': 'West Store',
        'status': 'Pending',
        'eta': '1 hour',
        'items': 32,
      },
    ],
    'Cooking': [
      {
        'location': 'Main Kitchen',
        'status': 'Ongoing',
        'meals': 200,
        'readyIn': '45 mins',
      },
      {
        'location': 'South Kitchen',
        'status': 'Pending',
        'meals': 150,
        'readyIn': '1.5 hours',
      },
    ],
    'Delivery': [
      {
        'destination': 'Downtown Shelter',
        'status': 'Ongoing',
        'meals': 75,
        'eta': '15 mins',
      },
      {
        'destination': 'West Center',
        'status': 'Pending',
        'meals': 100,
        'eta': '45 mins',
      },
    ],
  };

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'ongoing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.white,
              title: const Text(
                "Let's Share A Meal",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined,
                      color: Colors.black),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.person_outline, color: Colors.black),
                  onPressed: () {},
                ),
              ],
            ),
            // Dashboard Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metrics Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 4 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: metrics.length,
                      itemBuilder: (context, index) {
                        String key = metrics.keys.elementAt(index);
                        int value = metrics[key]!;
                        return _buildMetricCard(key, value);
                      },
                    ),
                    const SizedBox(height: 24),
                    // Role Status Cards
                    ...roleStatuses.entries.map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.key} Tasks',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: entry.value.length,
                              itemBuilder: (context, index) {
                                return _buildStatusCard(
                                    entry.key, entry.value[index]);
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMetricCard(String title, int value) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(String role, Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  role == 'Delivery' ? data['destination'] : data['location'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getStatusColor(data['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data['status'],
                    style: TextStyle(
                      color: getStatusColor(data['status']),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              'Time',
              data.containsKey('eta')
                  ? data['eta']
                  : data.containsKey('readyIn')
                      ? data['readyIn']
                      : '-',
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              role == 'Cooking' ? 'Meals' : 'Items',
              data.containsKey('meals')
                  ? '${data['meals']} meals'
                  : '${data['items']} items',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 36),
              ),
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
