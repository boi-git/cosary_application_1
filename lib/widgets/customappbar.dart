import 'package:cosary_application_1/widgets/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? tittle;

  const CustomAppBar({
    Key? key,
    this.tittle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: orangeColor),
      // title: tittle == null
      //     ? Text('')
      //     : GestureDetector(
      //         onTap: () {
      //           Navigator.push(context, MaterialPageRoute(
      //             builder: (context) {
      //               return ClassBackDetailRefined(coursename: 'CSCI 1303');
      //             },
      //           ));
      //         },
      //         child: Text(tittle!)),
      leading: const Padding(
        padding: EdgeInsets.all(5.0),
        // child: Image(
        //   image: AssetImage('lib/images/iiumlogo.png'),
        // ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: orangeColor,
          height: 4,
        ),
      ),
      // ignore: prefer_const_constructors
      backgroundColor: Color.fromARGB(255, 37, 39, 51),
    );
  }

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);
}
