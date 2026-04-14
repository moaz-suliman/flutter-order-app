import 'package:final_project/controllers/auth_provider.dart';
import 'package:final_project/controllers/order_provider.dart';
import 'package:final_project/core/constents/app_color.dart';
import 'package:final_project/core/constents/app_textStyle.dart';
import 'package:final_project/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = context.read<AuthProvider>();
      if (auth.user != null) {
        context.read<OrderProvider>().getUserOrders(auth.user!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final double sw = MediaQuery.of(context).size.width;
    final double sh = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          elevation: 0,
          title: Text('Order History', style: AppTextstyle.h3),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppColor.primary,
            labelColor: AppColor.primary,
            unselectedLabelColor: AppColor.grey,
            labelStyle: AppTextstyle.h2.copyWith(
                fontSize: sw * 0.035, fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: orderProvider.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColor.primary))
            : TabBarView(
                children: [
                  _buildOrderList(orderProvider.orders, sw, sh),
                  _buildOrderList(
                      orderProvider.orders
                          .where((o) =>
                              o.status == 'Pending' ||
                              o.status == 'Processing')
                          .toList(),
                      sw,
                      sh),
                  _buildOrderList(
                      orderProvider.orders
                          .where((o) =>
                              o.status == 'Delivered' ||
                              o.status == 'Completed')
                          .toList(),
                      sw,
                      sh),
                ],
              ),
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders, double sw, double sh) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: sw * 0.2,
                color: AppColor.grey.withOpacity(0.3)),
            SizedBox(height: sh * 0.02),
            Text('No orders found',
                style: AppTextstyle.h2.copyWith(color: AppColor.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: sw * 0.04, vertical: sh * 0.02),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index], sw, sh);
      },
    );
  }

  Widget _buildOrderCard(OrderModel order, double sw, double sh) {
    String formattedDate =
        DateFormat('MMM dd, yyyy').format(order.createdAt);

    return Container(
      margin: EdgeInsets.only(bottom: sh * 0.02),
      padding: EdgeInsets.all(sw * 0.04),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(sw * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.length > 5 ? order.id.substring(0, 5).toUpperCase() : order.id.toUpperCase()}',
                style: AppTextstyle.body.copyWith(
                    fontWeight: FontWeight.bold, fontSize: sw * 0.04),
              ),
              Row(
                children: [
                  _buildStatusBadge(order.status, sw, sh),
                  SizedBox(width: sw * 0.02),

                  GestureDetector(
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Order'),
                          content: const Text(
                              'Are you sure you want to delete this order?'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && mounted) {
                        final auth = context.read<AuthProvider>();
                        await context.read<OrderProvider>().deleteOrder(
                              order.id,
                              auth.user!.uid,
                            );
                      }
                    },
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red.withOpacity(0.7),
                      size: sw * 0.05,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: sh * 0.01),
          const Divider(height: 20),
          SizedBox(height: sh * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formattedDate,
                      style: AppTextstyle.h2.copyWith(
                          fontSize: sw * 0.035, color: AppColor.grey)),
                  SizedBox(height: sh * 0.005),
                  Text('${order.items.length} Items',
                      style: AppTextstyle.h2.copyWith(
                          fontSize: sw * 0.03,
                          color: AppColor.primary)),
                ],
              ),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: AppTextstyle.body.copyWith(
                  color: AppColor.primary,
                  fontSize: sw * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, double sw, double sh) {
    Color color;
    switch (status) {
      case 'Delivered':
      case 'Completed':
        color = Colors.green;
        break;
      case 'Pending':
      case 'Processing':
        color = Colors.orange;
        break;
      default:
        color = AppColor.primary;
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: sw * 0.03, vertical: sh * 0.005),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(sw * 0.02),
      ),
      child: Text(
        status,
        style: TextStyle(
            color: color,
            fontSize: sw * 0.03,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}