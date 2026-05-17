import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/order_model.dart';
import 'package:intl/intl.dart';

class PdfInvoiceService {
  static Future<Uint8List> generateInvoice(OrderModel order) async {
    final pdf = pw.Document();

    // Try to load a custom font, but fallback to default if not available
    final font = await PdfGoogleFonts.interRegular();
    final fontBold = await PdfGoogleFonts.interBold();

    final primaryColor = PdfColor.fromHex('#4CAF50'); // Assuming green primary theme
    final secondaryColor = PdfColor.fromHex('#757575');
    final darkColor = PdfColor.fromHex('#212121');

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData(
            defaultTextStyle: pw.TextStyle(font: font, color: darkColor, fontSize: 12),
          ),
        ),
        header: (context) => _buildHeader(primaryColor, secondaryColor, fontBold, order),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildCustomerDetails(order, fontBold, primaryColor),
          pw.SizedBox(height: 30),
          _buildInvoiceTable(order, fontBold, primaryColor),
          pw.SizedBox(height: 20),
          _buildTotal(order, fontBold, primaryColor),
          pw.SizedBox(height: 40),
          _buildFooter(secondaryColor),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(
      PdfColor primary, PdfColor secondary, pw.Font fontBold, OrderModel order) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'QuickBasket',
                  style: pw.TextStyle(
                    color: primary,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 28,
                    font: fontBold,
                  ),
                ),
                pw.Text(
                  'Fresh Groceries Delivered Fast',
                  style: pw.TextStyle(color: secondary, fontSize: 10),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'TAX INVOICE',
                  style: pw.TextStyle(
                    fontSize: 24,
                    color: primary,
                    fontWeight: pw.FontWeight.bold,
                    font: fontBold,
                    letterSpacing: 1.5,
                  ),
                ),
                pw.Text(
                  'Invoice #: ${order.id.substring(0, 8).toUpperCase()}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.Text(
                  'Date: ${DateFormat('dd MMM yyyy').format(order.createdAt)}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Divider(color: primary, thickness: 2),
      ],
    );
  }

  static pw.Widget _buildCustomerDetails(
      OrderModel order, pw.Font fontBold, PdfColor primaryColor) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              order.customerName,
              style: pw.TextStyle(
                color: primaryColor,
                fontWeight: pw.FontWeight.bold,
                font: fontBold,
                fontSize: 16,
              ),
            ),
            pw.Container(
              width: 200,
              child: pw.Text(order.customerAddress),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Order Status:',
              style: pw.TextStyle(
                color: primaryColor,
                fontWeight: pw.FontWeight.bold,
                font: fontBold,
                fontSize: 14,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: pw.BoxDecoration(
                color: primaryColor,
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
              ),
              child: pw.Text(
                order.status.toUpperCase(),
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                  font: fontBold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildInvoiceTable(
      OrderModel order, pw.Font fontBold, PdfColor primaryColor) {
    final headers = ['Item Description', 'Qty', 'Unit Price', 'Total'];

    final data = order.items.map((item) {
      return [
        item.productName,
        '${item.quantity}',
        '₹ ${item.price.toStringAsFixed(2)}',
        '₹ ${item.total.toStringAsFixed(2)}',
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontWeight: pw.FontWeight.bold,
        font: fontBold,
      ),
      headerDecoration: pw.BoxDecoration(
        color: primaryColor,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
      },
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }

  static pw.Widget _buildTotal(
      OrderModel order, pw.Font fontBold, PdfColor primaryColor) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Text(
            'Grand Total: ',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              font: fontBold,
            ),
          ),
          pw.Text(
            '₹ ${order.totalAmount.toStringAsFixed(2)}',
            style: pw.TextStyle(
              fontSize: 20,
              color: primaryColor,
              fontWeight: pw.FontWeight.bold,
              font: fontBold,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(PdfColor secondary) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(color: secondary, thickness: 0.5),
        pw.SizedBox(height: 8),
        pw.Text(
          'Thank you for shopping with QuickBasket!',
          style: pw.TextStyle(color: secondary, fontSize: 12),
        ),
        pw.Text(
          'For any queries, please contact support@quickbasket.com',
          style: pw.TextStyle(color: secondary, fontSize: 10),
        ),
      ],
    );
  }
}
