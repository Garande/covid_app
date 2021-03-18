import 'package:cached_network_image/cached_network_image.dart';
import 'package:covid_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String photoUrl;
  final String defaultLetter;
  final double size;
  final BorderRadius borderRadius;
  final Color background;

  const Avatar({
    this.photoUrl,
    this.defaultLetter,
    this.size,
    this.borderRadius,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          borderRadius != null ? borderRadius : BorderRadius.circular(50),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius:
              borderRadius != null ? borderRadius : BorderRadius.circular(50),
          color: AppTheme.primaryColor,
        ),
        child: photoUrl != null && photoUrl != ''
            ? CachedNetworkImage(
                imageUrl: photoUrl,
                fit: BoxFit.cover,
                height: size,
                width: size,
              )
            : defaultLetter != null && defaultLetter != ''
                ? Center(
                    child: Text(
                      defaultLetter,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Image.asset(
                    'assets/images/default_user_profile.png',
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  ),
      ),
    );
  }
}
