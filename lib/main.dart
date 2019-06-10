import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.white),
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(),
          body: buildBody(),
        ),
      );

  PreferredSize buildAppBar() =>
      PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AppBar(
              elevation: 0.1,
              title: Text(
                "Stocks",
                style: TextStyle(fontSize: 32),
              ),
              centerTitle: true,
            ),
          ],
        ),
      );

  ListView buildBody() {
    var list = Presenter().getList();

    return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext ctxt, int index) {
          return buildRow(list[index]);
        });
  }

  Padding buildRow(Stock stock) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              stock.name,
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              stock.unit,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              stock.quant,
              style: TextStyle(fontSize: 16),
            ),
            Text(
              stock.amount,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      );
}

class Stock {
  String name, unit, quant, amount;

  Stock(String name, String unit, String quant, String amount) {
    this.name = name;
    this.unit = unit;
    this.quant = quant;
    this.amount = amount;
  }
}

class Presenter {
  List<Stock> getList() =>
      [
        Stock("LINX3", "32,00", "300", "9600,00"),
        Stock("LINX3", "32,00", "300", "9600,00"),
        Stock("LINX3", "32,00", "300", "9600,00"),
        Stock("LINX3", "32,00", "300", "9600,00"),
        Stock("LINX3", "32,00", "300", "9600,00"),
        Stock("LINX3", "32,00", "300", "9600,00"),
        Stock("LINX3", "32,00", "300", "9600,00"),
        Stock("LINX3", "32,00", "300", "9600,00"),
        Stock("LINX3", "32,00", "300", "9600,00"),
        Stock("LINX3", "32,00", "300", "9600,00")
      ];
}

class Business {
  //https://query1.finance.yahoo.com/v1/finance/quoteType/?symbol=ITUB4.SA
  //https://query1.finance.yahoo.com/v8/finance/chart/ITUB4.SA?interval=1d

  String url =
      'https://query1.finance.yahoo.com/v8/finance/chart/ITUB4.SA?interval=1d';

  Future<http.Response> fetchPost() {
    return http.get(url);
  }
}

class Chart {
  List<Result> result;
  String error;

  Chart({this.result, this.error});

  factory Chart.fromJson(Map<String, dynamic> json) {
    var list = json['result'] as List;
    return Chart(
        result: list.map((i) => Result.fromJson(i)).toList(),
        error: json['error']
    );
  }
}

class Result {
  Indicators indicators;

  Result({this.indicators});

  factory Result.fromJson(Map<String, dynamic> json){
    return Result(
        indicators: Indicators.fromJson(json['indicators'])
    );
  }
}

class Indicators {
  List<double> high;
  List<double> close;
  List<double> low;
  List<double> open;

  Indicators({this.high, this.close, this.low, this.open});

  factory Indicators.fromJson(Map<String, dynamic> json){
    return Indicators(
        high: json['high'].cast<double>(),
        close: json['close'].cast<double>(),
        low: json['low'].cast<double>(),
        open: json['open'].cast<double>()
    );
  }
}
