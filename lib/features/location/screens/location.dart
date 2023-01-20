// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cosary_application_1/common/widgets/customglassmorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'package:cosary_application_1/widgets/colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class Location extends ConsumerStatefulWidget {
  const Location({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationState();
}

class _LocationState extends ConsumerState<Location> {
  String first = '';
  String mid = '';
  String last = '';
  String info1 = '';
  String info2 = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              interactiveFlags: InteractiveFlag.none,
              enableScrollWheel: false,
              maxBounds: LatLngBounds(
                LatLng(3.262411, 101.729711),
                LatLng(3.241102, 101.741749),
              ),
              // center: LatLng(3.25166566, 101.73583039),
              center: LatLng(3.24956566, 101.73453039),
              zoom: 15.5,
              maxZoom: 15.5,
            ),
            nonRotatedChildren: [
              AttributionWidget.defaultWidget(
                source: 'OpenStreetMap contributors',
                onSourceTapped: () {},
              )
            ],
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: [
                  //3.249711, 101.738898
                  Marker(
                      //Salahuddin
                      point: LatLng(3.255036, 101.739278),
                      width: 80,
                      height: 80,
                      builder: ((context) {
                        return GestureDetector(
                          onTap: (() {
                            setState(() {
                              first = 'Celpad';
                              info1 = '7 min (2.7km)';
                              mid = 'Salahuddin';
                              info2 = '10 min (3.3km)';
                              last = 'Econs';
                            });
                          }),
                          child: const Icon(
                            Icons.location_on,
                            color: orangeColor,
                          ),
                        );
                      })),
                  Marker(
                      //Econs
                      point: LatLng(3.249711, 101.738898),
                      width: 80,
                      height: 80,
                      builder: ((context) {
                        return GestureDetector(
                          onTap: (() {
                            setState(() {
                              first = 'Salahuddin';
                              info1 = '6 min (2.7km)';

                              mid = 'Econs';
                              info2 = '6 min (2.3km)';
                              last = 'Kaed';
                            });
                          }),
                          child: const Icon(
                            Icons.location_on,
                            color: orangeColor,
                          ),
                        );
                      })),
//LatLng(3.255036, 101.739278),LatLng(3.249711, 101.738898),
                  //3.250657, 101.731274

                  Marker(
                      //Kaed
                      point: LatLng(3.250657, 101.731274),
                      width: 80,
                      height: 80,
                      builder: ((context) {
                        return GestureDetector(
                          onTap: (() {
                            setState(() {
                              first = 'Econs';
                              info1 = '6 min (2.3km)';
                              mid = 'Kaed';
                              info2 = '8 min (3.0km)';

                              last = 'Kict';
                            });
                          }),
                          child: const Icon(
                            Icons.location_on,
                            color: orangeColor,
                          ),
                        );
                      })),

                  //3.254223, 101.729082
                  Marker(
                      //Kict
                      point: LatLng(3.254223, 101.729082),
                      width: 80,
                      height: 80,
                      builder: ((context) {
                        return GestureDetector(
                          onTap: (() {
                            setState(() {
                              first = 'Kaed';
                              info1 = '8 min (3.0km)';
                              mid = 'Kict';
                              info2 = '5 min (2.2km)';
                              last = 'Koe';
                            });
                          }),
                          child: const Icon(
                            Icons.location_on,
                            color: orangeColor,
                          ),
                        );
                      })),

                  //3.254253, 101.732147

                  Marker(
                      //Kict
                      point: LatLng(3.254253, 101.732147),
                      width: 80,
                      height: 80,
                      builder: ((context) {
                        return GestureDetector(
                          onTap: (() {
                            setState(() {
                              first = 'Kict';
                              info1 = '5 min (2.2km)';
                              mid = 'Koe';
                              info2 = '12 min (3.7km)';
                              last = 'Ruqayyah';
                            });
                          }),
                          child: const Icon(
                            Icons.location_on,
                            color: orangeColor,
                          ),
                        );
                      })),

                  //3.257371, 101.733601

                  Marker(
                      //ruq
                      point: LatLng(3.257371, 101.733601),
                      width: 80,
                      height: 80,
                      builder: ((context) {
                        return GestureDetector(
                          onTap: (() {
                            setState(() {
                              first = 'Koe';
                              info1 = '12 min (3.7km)';
                              mid = 'Ruqayyah';
                              info2 = '15 min (4.1km)';
                              last = 'Celpad';
                            });
                          }),
                          child: const Icon(
                            Icons.location_on,
                            color: orangeColor,
                          ),
                        );
                      })),

                  //3.253049, 101.735903

                  Marker(
                      //ruq
                      point: LatLng(3.253049, 101.735903),
                      width: 80,
                      height: 80,
                      builder: ((context) {
                        return GestureDetector(
                          onTap: (() {
                            setState(() {
                              first = 'Ruqayyah';
                              info1 = '15 min (4.1km)';
                              mid = 'Celpad';
                              info2 = '16 min (4.3km)';
                              last = 'Salahuddin';
                            });
                          }),
                          child: const Icon(
                            Icons.location_on,
                            color: orangeColor,
                          ),
                        );
                      })),

                  //3.252456, 101.729721

                  Marker(
                      //ruq
                      point: LatLng(3.252456, 101.729721),
                      width: 80,
                      height: 80,
                      builder: ((context) {
                        return const Icon(Icons.directions_bus_sharp, color: darkColor);
                      })),

                  //3.252634, 101.736004

                  Marker(
                      //ruq
                      point: LatLng(3.252640, 101.736009),
                      width: 80,
                      height: 80,
                      builder: ((context) {
                        return const Icon(Icons.directions_bus_sharp, color: darkColor);
                      })),

                  //3.250437, 101.739151

                  Marker(
                      //ruq
                      point: LatLng(3.250437, 101.739151),
                      width: 80,
                      height: 80,
                      builder: ((context) {
                        return const Icon(Icons.directions_bus_sharp, color: darkColor);
                      })),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 30,
            left: 15,
            child: Container(
              height: size.height / 3.5,
              width: size.width - 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)), color: darkColor),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(
                          width: size.width / 2.5,
                          height: 50,
                          child: TimelineTile(
                            beforeLineStyle: LineStyle(color: orangeColor),
                            afterLineStyle: LineStyle(color: orangeColor),
                            indicatorStyle: IndicatorStyle(
                              color: orangeColor,
                              width: 35,
                              iconStyle: IconStyle(
                                iconData: Icons.keyboard_double_arrow_down,
                                color: darkColor,
                                fontSize: 30,
                              ),
                            ),
                            endChild: ListTile(
                              subtitle: Text(
                                info1,
                              ),
                              title: Text(
                                first,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 2.5,
                          height: 100,
                          child: TimelineTile(
                            beforeLineStyle: LineStyle(color: orangeColor.withOpacity(0.4)),
                            afterLineStyle: LineStyle(color: orangeColor.withOpacity(0.1)),
                            indicatorStyle: IndicatorStyle(
                              width: 35,
                              iconStyle: IconStyle(
                                iconData: Icons.location_on,
                                color: darkColor,
                                fontSize: 30,
                              ),
                            ),
                            endChild: ListTile(title: Text(mid)),
                          ),
                        ),
                        SizedBox(
                          width: size.width / 2.5,
                          height: 50,
                          child: TimelineTile(
                            beforeLineStyle: LineStyle(color: orangeColor.withOpacity(0.1)),
                            indicatorStyle: IndicatorStyle(
                              width: 35,
                              iconStyle: IconStyle(
                                iconData: Icons.keyboard_double_arrow_down,
                                color: darkColor,
                                fontSize: 30,
                              ),
                            ),
                            endChild: ListTile(
                              title: Text(last),
                              subtitle: Text(info2),
                            ),
                          ),
                        )
                      ]),
                    ),
                    Container(
                      width: size.width / 2.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)), color: orangeColor),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.directions_bus_filled,
                              size: 40,
                            ),
                            Text('Bus A'),
                            Text('Kict : 12:05pm '),
                            Icon(
                              Icons.directions_bus_filled,
                              size: 40,
                            ),
                            Text('Bus B to Econs'),
                            Text('Koe : 12:10pm '),
                            Icon(
                              Icons.directions_bus_filled,
                              size: 40,
                            ),
                            Text('Bus C'),
                            Text('Salahuddin : 12:15pm ')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
