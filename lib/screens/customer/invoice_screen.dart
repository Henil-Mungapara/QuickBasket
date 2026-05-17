import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/order_model.dart';
import '../../services/pdf_invoice_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printing/printing.dart';

class InvoiceScreen extends StatelessWidget {
  final OrderModel order;
  const InvoiceScreen({super.key, required this.order});

  Future<Map<String, String>> _fetchCustomerDetails() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(order.userId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'name': data['name'] ?? order.customerName,
          'address': data['address'] ?? order.customerAddress,
        };
      }
    } catch (e) {
      // Fallback to order details on error
    }
    return {
      'name': order.customerName,
      'address': order.customerAddress,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Invoice',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _fetchCustomerDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          final customerName = snapshot.data?['name'] ?? order.customerName;
          final customerAddress = snapshot.data?['address'] ?? order.customerAddress;

          // Create a new OrderModel with the updated customer details for PDF generation
          final updatedOrder = OrderModel(
            id: order.id,
            userId: order.userId,
            customerName: customerName,
            customerAddress: customerAddress,
            items: order.items,
            totalAmount: order.totalAmount,
            status: order.status,
            deliveryPersonId: order.deliveryPersonId,
            deliveryPersonName: order.deliveryPersonName,
            createdAt: order.createdAt,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 12,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.receipt_long,
                              color: AppColors.primary, size: 36),
                        ),
                        const SizedBox(height: 12),
                        const Text('QuickBasket',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        const Text('Tax Invoice',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 12),

                  _row('Order ID', updatedOrder.id),
                  const SizedBox(height: 8),
                  Text(
                    customerName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    customerAddress,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  _row('Status', updatedOrder.status),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  const Text('Items',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Text('Product',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.textSecondary))),
                      Expanded(
                          child: Text('Qty',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.textSecondary))),
                      Expanded(
                          child: Text('Price',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.textSecondary))),
                    ],
                  ),
                  const Divider(height: 16),
                  ...updatedOrder.items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(item.productName,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textPrimary))),
                            Expanded(
                                child: Text('${item.quantity}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.textPrimary))),
                            Expanded(
                                child: Text(
                                    '₹${item.total.toStringAsFixed(0)}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary))),
                          ],
                        ),
                      )),
                  const Divider(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Grand Total',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      Text('₹${updatedOrder.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 28),

                  Row(
                    children: [
                      Expanded(
                        child: UIHelper.customButton(
                          text: '📄 Download',
                          onPressed: () async {
                            try {
                              final pdfBytes = await PdfInvoiceService.generateInvoice(updatedOrder);
                              await Printing.sharePdf(
                                bytes: pdfBytes,
                                filename: 'invoice_${updatedOrder.id}.pdf',
                              );
                            } catch (e) {
                              if (context.mounted) {
                                UIHelper.showSnackBar(context, 'Error generating PDF: $e', isError: true);
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: UIHelper.customButton(
                          text: '🖨️ Print',
                          backgroundColor: AppColors.secondary,
                          onPressed: () async {
                            try {
                              final pdfBytes = await PdfInvoiceService.generateInvoice(updatedOrder);
                              await Printing.layoutPdf(
                                onLayout: (format) async => pdfBytes,
                                name: 'Invoice ${updatedOrder.id}',
                              );
                            } catch (e) {
                              if (context.mounted) {
                                UIHelper.showSnackBar(context, 'Error printing PDF: $e', isError: true);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
