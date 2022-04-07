// import 'package:flutter/material.dart';
//
// import '../config/palette.dart';
// import '../config/styles.dart';
//
// StatefulBuilder dialogPowerWidget(
//     double screenHeight, double screenWidth, String device) {
//   return StatefulBuilder(builder: (context, setState) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         SizedBox(
//           height: screenHeight * 0.03,
//         ),
//         if (device != "펌프" && device !="외부 팬")
//           Container(
//             width: screenWidth * 0.6,
//             height: screenHeight * 0.1,
//             child: Material(
//               elevation: 14.0,
//               borderRadius: BorderRadius.circular(24.0),
//               shadowColor: Palette.shadowColor,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Text('$device 전원', style: Styles.headLineStyle),
//                             SizedBox(
//                               width: screenWidth * 0.05,
//                             ),
//                             powerMaterial(device)
//                           ],
//                         )
//                       ],
//                     ),
//                   ]),
//             ),
//           ),
//         if (device == "펌프" || device == "외부 팬")
//           Container(
//             width: screenWidth * 0.6,
//             height: screenHeight * 0.1,
//             child: Material(
//               elevation: 14.0,
//               borderRadius: BorderRadius.circular(24.0),
//               shadowColor: Palette.shadowColor,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             InkWell(
//                                 onTap: () {
//                                   pumpBool = !pumpBool;
//                                   pumpBool
//                                       ? switchControl.switchFirstOff(device)
//                                       : switchControl.switchFirstOn(device);
//                                 },
//                                 child: Text('${device}1',
//                                     style: Styles.StaggeredGridStyle)),
//                             SizedBox(
//                               width: screenWidth * 0.05,
//                             ),
//                             SizedBox(
//                               width: screenWidth * 0.05,
//                             ),
//                             InkWell(
//                                 onTap: () {
//                                   pump2Bool = !pump2Bool;
//                                   pump2Bool
//                                       ? switchControl.switchSecondOff(device)
//                                       : switchControl.switchSecondOn(device);
//                                 },
//                                 child: Text('${device}2', style: Styles.StaggeredGridStyle)),
//                           ],
//                         )
//                       ],
//                     ),
//                   ]),
//             ),
//           ),
//         SizedBox(
//           height: screenHeight*0.03,
//         ),
//         if (device == "모터")
//           Container(
//             width: screenWidth * 0.6,
//             height: screenHeight * 0.1,
//             child: Material(
//               elevation: 14.0,
//               borderRadius: BorderRadius.circular(24.0),
//               shadowColor: Palette.shadowColor,
//               child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     motorControl.motorLeft();
//                                     grpc.sensingV();
//                                     //grpc 명령어
//                                   });
//                                 },
//                                 child: Text(
//                                   "좌회전",
//                                   style: Styles.dialogTileStyle,
//                                 )),
//                             SizedBox(
//                               width: screenWidth * 0.03,
//                             ),
//                             InkWell(
//                                 onTap: () {
//                                   setState(() {
//                                     motorControl.motorRight();
//                                     grpc.sensingV();
//                                     //grpc 명령어
//                                   });
//                                 },
//                                 child: Text("우회전",
//                                     style: Styles.dialogTileStyle)),
//                           ],
//                         )
//                       ],
//                     ),
//                   ]),
//             ),
//           ),
//         SizedBox(
//           height: screenHeight * 0.03,
//         ),
//         if (device == "모터")
//           Container(
//             width: screenWidth * 0.6,
//             height: screenHeight * 0.1,
//             child: InkWell(
//               onTap: () {
//                 setState(() {
//                   grpc.sensingV();
//                   //grpc 명령어
//                 });
//               },
//               child: Material(
//                 elevation: 14.0,
//                 borderRadius: BorderRadius.circular(24.0),
//                 shadowColor: Palette.shadowColor,
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "전압",
//                                     style: Styles.StaggeredGridStyle,
//                                   ),
//                                   if (sensor1redVData != null)
//                                     Text(
//                                       "$sensor1redVData",
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.blueAccent),
//                                     ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 width: screenWidth * 0.1,
//                               ),
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "전류",
//                                     style: Styles.StaggeredGridStyle,
//                                   ),
//                                   if (sensor1redVData != null)
//                                     Text(
//                                       "$sensor1redAData",
//                                       style: TextStyle(
//                                           fontSize: 18,
//                                           color: Colors.blueAccent),
//                                     ),
//                                 ],
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ]),
//               ),
//             ),
//           ),
//         SizedBox(
//           height: screenHeight * 0.03,
//         ),
//         //미완성
//         if (device == "test")
//           Container(
//             width: screenWidth * 0.6,
//             height: screenHeight * 0.15,
//             child: InkWell(
//               onTap: () {
//
//               },
//               child: Material(
//                 elevation: 14.0,
//                 borderRadius: BorderRadius.circular(24.0),
//                 shadowColor: Palette.shadowColor,
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text('시작 시간', style: Styles.dialogTileStyle),
//                               SizedBox(
//                                 width: screenWidth * 0.05,
//                               ),
//                               DropdownButton(
//                                   isDense: true,
//                                   value: pumpInitialize,
//                                   onChanged: (String value) {
//                                     setState(() {
//                                       pumpInitialize = value;
//                                       //grpc 명령어
//                                     });
//                                   },
//                                   items: controlPeriod.map((String title) {
//                                     return DropdownMenuItem(
//                                       value: title,
//                                       child: Text(title,
//                                           style: TextStyle(
//                                               color: Colors.blue,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 22.0)),
//                                     );
//                                   }).toList()),
//                             ],
//                           ),
//                           SizedBox(
//                             height: screenHeight * 0.01,
//                           ),
//                           Row(
//                             children: [
//                               Text('종료 시간', style: Styles.dialogTileStyle),
//                               SizedBox(
//                                 width: screenWidth * 0.05,
//                               ),
//                               DropdownButton(
//                                   isDense: true,
//                                   value: pumpInitialize,
//                                   onChanged: (String value) {
//                                     setState(() {
//                                       pumpInitialize = value;
//                                       //grpc 명령어
//                                     });
//                                   },
//                                   items: controlPeriod.map((String title) {
//                                     return DropdownMenuItem(
//                                       value: title,
//                                       child: Text(title,
//                                           style: TextStyle(
//                                               color: Colors.blue,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 22.0)),
//                                     );
//                                   }).toList())
//                             ],
//                           )
//                         ],
//                       ),
//                     ]),
//               ),
//             ),
//           ),
//         SizedBox(
//           height: screenHeight * 0.03,
//         ),
//       ],
//     );
//   });
// }