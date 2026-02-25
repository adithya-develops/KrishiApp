import 'dart:ui';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressed;
  final bool loading;

  const GlassButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: loading ? null : onPressed,

      child: ClipRRect(

        borderRadius: BorderRadius.circular(18),

        child: BackdropFilter(

          filter: ImageFilter.blur(
            sigmaX: 20,
            sigmaY: 20,
          ),

          child: Container(

            width: double.infinity,
            height: 55,

            alignment: Alignment.center,

            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(18),

              gradient: LinearGradient(

                colors: [

                  Colors.white.withOpacity(.18),
                  Colors.white.withOpacity(.05),

                ],

              ),

              border: Border.all(
                color: Colors.white.withOpacity(.25),
              ),

            ),

            child: loading

                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )

                : Text(

                    text,

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 18,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

          ),

        ),

      ),

    );

  }

}
