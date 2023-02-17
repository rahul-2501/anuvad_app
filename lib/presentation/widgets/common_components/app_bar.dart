
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnuvadAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AnuvadAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          height: 28,
          width: 18,
          child: Image.asset("assets/images/bluetooth_enabled_icon.png"),
        )],
      elevation: 3,
      shadowColor: const Color(0xffA3A8B4).withOpacity(0.10),
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Text('CI', style: GoogleFonts.poppins(color: Colors.black,fontSize: 40,fontWeight: FontWeight.w200)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
