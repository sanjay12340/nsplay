import 'package:nsplay/models/game_time_table_model.dart';
import 'package:nsplay/services/genral_api_call.dart';
import 'package:flutter/material.dart';

class TimeTablePage extends StatefulWidget {
  TimeTablePage({Key? key}) : super(key: key);

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  GenralApiCallService? genralApiCallService;
  @override
  void initState() {
    super.initState();
    genralApiCallService = GenralApiCallService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Table"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: genralApiCallService!.fetchGenralQueryWithRawData(
            "SELECT `id`, `game_name`, time_format(`open_time`,'%h:%i %p') as open_time,time_format(`open_time`,'%H%i') as open_time2, time_format(`close_time`,'%h:%i %p') as close_time, `game_on_off`, `days`, `price` FROM `game` order by open_time2"),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Text("No Internet Connection"),
                  ),
                ],
              );

            case ConnectionState.waiting:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              );

            default:
              if (snapshot.hasData) {
                if (snapshot.data != null) {
                  List<GameTimeTableModel> l =
                      gameTimeTableModelFromJson(snapshot.data.toString());
                  return Column(
                    children: [
                      Table(
                          columnWidths: {
                            0: FlexColumnWidth(1.5),
                          },
                          border: TableBorder.all(),
                          children: [
                            TableRow(children: [
                              TableCellResultHead(text: "Game Name"),
                              TableCellResultHead(text: "Open Time"),
                              TableCellResultHead(text: "Close Time"),
                            ])
                          ]),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Table(
                          columnWidths: {
                            0: FlexColumnWidth(1.5),
                          },
                          border: TableBorder.all(),
                          children: List.generate(l.length, (index) {
                            return TableRow(children: [
                              TableCellResult(text: l[index].gameName!),
                              TableCellResult(text: l[index].openTime!),
                              TableCellResult(text: l[index].closeTime!),
                            ]);
                          }),
                        ),
                      ))
                    ],
                  );
                }
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}

class TableCellResult extends StatelessWidget {
  const TableCellResult({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "$text",
        textAlign: TextAlign.center,
      ),
    ));
  }
}

class TableCellResultHead extends StatelessWidget {
  const TableCellResultHead({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String? text;

  @override
  Widget build(BuildContext context) {
    return TableCell(
        child: Container(
      color: Colors.red.shade900,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "$text",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    ));
  }
}
