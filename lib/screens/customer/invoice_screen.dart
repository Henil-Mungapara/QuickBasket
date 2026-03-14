import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../helpers/ui_helper.dart';
import '../../models/order_model.dart';

/// Invoice Screen — view, download, and print invoice.
class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = ModalRoute.of(context)?.settings.arguments as OrderModel?;

    // Use dummy if no argument passed
    final o = order ?? OrderModel.dummyOrders.first;

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
      body: SingleChildScrollView(
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
              // ── Header ─────────────────────────────────
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

              // ── Order Info ─────────────────────────────
              _row('Order ID', o.id),
              _row('Customer', o.customerName),
              _row('Address', o.customerAddress),
              _row('Status', o.status),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),

              // ── Items Table ────────────────────────────
              const Text('Items',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              // Header
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
              ...o.items.map((item) => Padding(
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

              // ── Total ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Grand Total',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  Text('₹${o.totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 28),

              // ── Action Buttons ─────────────────────────
              Row(
                children: [
                  Expanded(
                    child: UIHelper.customButton(
                      text: '📄 Download',
                      onPressed: () {
                        // TODO: Integrate flutter pdf package to generate PDF invoice.
                        UIHelper.showSnackBar(context,
                            'PDF download will be available after integration');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: UIHelper.customButton(
                      text: '🖨️ Print',
                      backgroundColor: AppColors.secondary,
                      onPressed: () {
                        // TODO: Integrate printing package for invoice printing.
                        UIHelper.showSnackBar(context,
                            'Printing will be available after integration');
                      },
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
