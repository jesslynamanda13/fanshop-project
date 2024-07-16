// import 'package:fanshop/arguments/user_argument.dart';
// import 'package:flutter/material.dart';

// class NavBar extends StatefulWidget {
//   final String uid;
//   final String username;
//   final String name;
//   const NavBar(
//       {Key? key, required this.uid, required this.username, required this.name})
//       : super(key: key);

//   @override
//   _NavBarState createState() => _NavBarState();
// }

// class _NavBarState extends State<NavBar> {
//   int _selectedIndex = 0;

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     switch (index) {
//       case 0:
//         Navigator.pushNamed(context, '/homepage');
//         break;
//       case 1:
//         // Add navigation for Favorites if needed
//         break;
//       case 2:
//         Navigator.of(context).pushNamed("/homepage",
//             arguments: UserArgument(widget.uid, widget.username, widget.name));
//         break;
//       case 3:
//         Navigator.pushNamed(context, '/profile');
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Color.fromARGB(255, 32, 32, 32),
//         selectedItemColor: const Color(0xFFFFE0B0),
//         unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.home,
//               size: 24.0,
//             ),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.favorite,
//               size: 24.0,
//             ),
//             label: 'Favorites',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.shop_rounded,
//               size: 24.0,
//             ),
//             label: 'Shop',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.person,
//               size: 24.0,
//             ),
//             label: 'Profile',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
