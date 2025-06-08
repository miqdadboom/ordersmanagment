import 'package:flutter/material.dart';
import 'package:final_tasks_front_end/core/constants/app_colors.dart';
import 'package:final_tasks_front_end/features/products/domain/entities/products_entity.dart';

class ProductCardHome extends StatefulWidget {
  final ProductEntity product;
  final String? discount;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;

  const ProductCardHome({
    super.key,
    required this.product,
    this.discount,
    required this.onTap,
    this.onAddToCart,
  });

  @override
  State<ProductCardHome> createState() => _ProductCardHomeState();
}

class _ProductCardHomeState extends State<ProductCardHome> {
  bool added = false;

  void _handleAddToCart() {
    setState(() {
      added = true;
    });
    widget.onAddToCart?.call();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardField,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(screenWidth * 0.03),
                  ),
                  child: Container(
                    height: screenHeight * 0.17,
                    width: double.infinity,
                    color: AppColors.cardWithoutImage,
                    child: Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: screenWidth * 0.1,
                              color: AppColors.imageNotSupported,
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            Text(
                              'No Image',
                              style: TextStyle(color: AppColors.noImageText),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.03,
                    screenWidth * 0.03,
                    screenWidth * 0.03,
                    screenWidth * 0.025,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.product.title,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenHeight * 0.0001),
                      Text(
                        widget.product.brand,
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: AppColors.textCardBrand,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${widget.product.price}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                              color: AppColors.priceOfCard,
                            ),
                          ),
                          GestureDetector(
                            onTap: _handleAddToCart,
                            child: Container(
                              width: screenWidth * 0.075,
                              height: screenWidth * 0.075,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                added ? Icons.check : Icons.add,
                                color: AppColors.iconSize,
                                size: screenWidth * 0.045,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.discount != null)
              Positioned(
                top: screenWidth * 0.02,
                right: screenWidth * 0.02,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.discountsOfCard,
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                  child: Text(
                    widget.discount!,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
