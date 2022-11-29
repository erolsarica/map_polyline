import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_polyline/fay_hatlari.dart';

class PolylinePage extends StatefulWidget {
  static const String route = 'polyline';

  const PolylinePage({Key? key}) : super(key: key);

  @override
  State<PolylinePage> createState() => _PolylinePageState();
}

class _PolylinePageState extends State<PolylinePage> {

  late Future<List<Polyline>> polylines;

  Future<List<Polyline>> getPolylines() async {
    final polyLines = [
      Polyline(
        points: [

          LatLng(40.170558, 24.968076),

        ],

        strokeWidth: 2,
        color: Colors.red,
      ),
    ];
    await Future<void>.delayed(const Duration(seconds: 3));
    return polyLines;
  }

  @override
  void initState() {
    polylines = getPolylines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var polyFay = FayHatlari.fayHatlari
        .map<Polyline>((e) =>
        Polyline(
            color: Colors.red,
            strokeWidth: 2,
            points: e.map((x) => LatLng(x.latitude, x.longitude)).toList()))
        .toList();

    return Scaffold(
        appBar: AppBar(title: const Text('Polylines')),
        //drawer: buildDrawer(context, PolylinePage.route),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder<List<Polyline>>(
            future: polylines,
            builder:
                (BuildContext context, AsyncSnapshot<List<Polyline>> snapshot) {
              debugPrint('snapshot: ${snapshot.hasData}');
              if (snapshot.hasData) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Text('Polylines'),
                    ),
                    Flexible(
                      child: FlutterMap(
                        options: MapOptions(
                          // haritanın döndürlümesini engeller
                          //interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                          center: LatLng(36, 36),
                          zoom: 4.5,
                          minZoom: 2.0,
                          maxZoom: 18.0,
                          onTap: (tapPosition, point) {
                            setState(() {
                              debugPrint('onTap');
                              polylines = getPolylines();
                            });
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                            'http://mt{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                            //'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                            'dev.fleaflet.flutter_map.example',
                          ),
                          PolylineLayer(
                             polylines: polyFay,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const Text(
                  'Harita yükleniyor...\n\nTamamlandığında harita verilerini yenilemek için haritaya dokunun.');
            },
          ),
        ));
  }
}