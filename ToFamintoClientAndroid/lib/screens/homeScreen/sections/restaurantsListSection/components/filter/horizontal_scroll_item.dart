// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:to_faminto_client/constants/app_style.dart';
// import 'package:to_faminto_client/constants/enums.dart';
// import 'package:to_faminto_client/providers/restaurants_state.dart';
//
// class HorizontalScrollItem extends StatefulWidget {
//   final Filter filterName;
//   final IconData iconData;
//   final String description;
//
//   const HorizontalScrollItem(
//       {@required this.filterName,
//       @required this.iconData,
//       @required this.description});
//   @override
//   _HorizontalScrollItemState createState() => _HorizontalScrollItemState();
// }
//
// class _HorizontalScrollItemState extends State<HorizontalScrollItem> {
//   bool _isPressed = false;
//   void _onPressed(context) {
//     Provider.of<RestaurantsState>(context, listen: false)
//         .toggleFilter(widget.filterName);
//
//     setState(() {
//       _isPressed = !_isPressed;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => _onPressed(context),
//       child: Container(
//         width: 60,
//         height: 60,
//         margin: const EdgeInsets.only(left: 15.0, right: 15.0),
//         decoration: BoxDecoration(
//           color: _isPressed ? Colors.white : null,
//           borderRadius: BorderRadius.all(
//             Radius.circular(9.0),
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               widget.iconData,
//               color: _isPressed ? AppStyle.yellow : Colors.white,
//               size: 36.0,
//             ),
//             Text(
//               widget.description,
//               style: _isPressed
//                   ? AppStyle.yellowRegularTextStyle()
//                   : AppStyle.whiteRegularText13Style(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
