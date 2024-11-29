import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:presensi_battuta_app/app/presentation/home/home_notifier.dart';
import 'package:presensi_battuta_app/app/presentation/map/map_notifier.dart';
import 'package:presensi_battuta_app/core/helper/global_helper.dart';
import 'package:presensi_battuta_app/core/helper/location_helper.dart';
import 'package:presensi_battuta_app/core/widget/app_widget.dart';
import 'package:presensi_battuta_app/core/widget/loading_app_widget.dart';

class MapScreen extends AppWidget<MapNotifier, void, void> {
  @override
  void checkVariableBeforeUi(BuildContext context) {
    if (!notifier.isGrantedLocation) {
      alternativeErrorButton = FilledButton(
        onPressed: () async {
          await LocationHelper.showDialogLocationPermission(context);
          notifier.checkLocationPermission();
        },
        child: Text("Setujui"),
      );
    } else if (!notifier.isEnabledLocation) {
      alternativeErrorButton = FilledButton(
        onPressed: () async {
          LocationHelper.openLocationSetting();
          notifier.checkLocationService();
        },
        child: Text("Buka Pengaturan Lokasi"),
      );
    }
    // else if (notifier.isMockedLocation) {
    //   alternativeErrorButton = FilledButton(
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //       child: Text("Tutup"));
    // }
    else {
      alternativeErrorButton = null;
    }
  }

  @override
  void checkVariableAfterUi(BuildContext context) {
    if (notifier.isSuccess) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  AppBar? appBarBuild(BuildContext context) {
    return AppBar(
      title: Text("Buat Kehadiran"),
    );
  }

  @override
  Widget bodyBuild(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: OSMFlutter(
            controller: notifier.mapController,
            osmOption: OSMOption(
                zoomOption: ZoomOption(
                    initZoom: 19, maxZoomLevel: 19, minZoomLevel: 10)),
            onMapIsReady: (p0) {
              if (p0) {
                notifier.mapIsReady();
              }
            },
            mapIsLoading: LoadingAppWidget(),
          ),
        ),
        _footerLayout(context),
      ],
    ));
  }

  _footerLayout(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: SizedBox()),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_city,
                        size: 30,
                      ),
                      SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notifier.schedule?.office.name ?? '',
                            style: GlobalHelper.getTextStyle(context,
                                appTextStyle: AppTextStyle.titleMedium),
                          ),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //       vertical: 2, horizontal: 5),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(4),
                          //       color: GlobalHelper.getColorScheme(context)
                          //           .primary),
                          //   child: Text(
                          //     "Programmer",
                          //     style: GlobalHelper.getTextStyle(context,
                          //             appTextStyle: AppTextStyle.bodySmall)
                          //         ?.copyWith(
                          //             color:
                          //                 GlobalHelper.getColorScheme(context)
                          //                     .onPrimary),
                          //   ),
                          // ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 7),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Icon(
                  //       Icons.access_time,
                  //       size: 30,
                  //     ),
                  //     SizedBox(width: 5),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Text(
                  //           notifier.schedule?.shift.name ?? '',
                  //           style: GlobalHelper.getTextStyle(context,
                  //               appTextStyle: AppTextStyle.titleMedium),
                  //         ),
                  //         Text(
                  //             "${notifier.schedule?.shift.startTime ?? ''} - ${notifier.schedule?.shift.endTime ?? ''}",
                  //             style: GlobalHelper.getTextStyle(context,
                  //                 appTextStyle: AppTextStyle.bodySmall)),
                  //       ],
                  //     )
                  //   ],
                  // ),
                ],
              ),
              Expanded(child: SizedBox()),
            ],
          ),
          SizedBox(height: 10),
          Container(
            width: double.maxFinite,
            child: FilledButton(
                onPressed:
                    (notifier.isEnableSubmitButton) ? _onPressSubmit : null,
                child: Text("Kirim Kehadiran")),
          ),
        ],
      ),
    );
  }

  _onPressSubmit() {
    notifier.send();
  }
}
