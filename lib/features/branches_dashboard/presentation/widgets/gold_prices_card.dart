import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../domain/models/branch_summary.dart';

/// Gold prices card showing prices for different karats
class GoldPricesCard extends StatelessWidget {
  final GoldPrices prices;

  const GoldPricesCard({
    super.key,
    required this.prices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF2A2A2A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFFFD700), // goldenNeon
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFA500).withOpacity(0.3), // goldenGlow
            blurRadius: 8,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFD4AF37),
                      Color(0xFFB8941E),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'أسعار الذهب',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'آخر تحديث: ${_formatLastUpdate(prices.lastUpdated)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Karat 24
          _buildKaratRow(
            karat: '24',
            pricePiastres: prices.karat24PricePerGramPiastres,
            color: Color(0xFFFFD700),
          ),
          SizedBox(height: 10),

          // Karat 21
          _buildKaratRow(
            karat: '21',
            pricePiastres: prices.karat21PricePerGramPiastres,
            color: Color(0xFFD4AF37),
          ),
          SizedBox(height: 10),

          // Karat 18
          _buildKaratRow(
            karat: '18',
            pricePiastres: prices.karat18PricePerGramPiastres,
            color: Color(0xFFB8941E),
          ),
        ],
      ),
    );
  }

  Widget _buildKaratRow({
    required String karat,
    required int pricePiastres,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.grade, color: color, size: 20),
          SizedBox(width: 8),
          Text(
            'عيار $karat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Text(
            _formatPrice(pricePiastres),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(width: 4),
          Text(
            'ج.م/جم',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(int piastres) {
    final egp = piastres / 100;
    return egp.toStringAsFixed(2);
  }

  String _formatLastUpdate(DateTime timestamp) {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    return timeago.format(timestamp, locale: 'ar');
  }
}
