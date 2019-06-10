import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primaryColor: Colors.white),
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(),
          body: buildBody2(),
        ),
      );

  PreferredSize buildAppBar() => PreferredSize(
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
    List<Stock> list = List();

    return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext ctxt, int index) {
          return buildRow(list[index]);
        });
  }

  Padding buildRow(Stock stock) => Padding(
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

  buildBody2() {
    Future<Chart> chart = Business().fetchPost();

    return FutureBuilder<Chart>(
      future: chart,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildRow(Stock(snapshot.data));
        } else {
          return Text("Waiting...");
        }
      },
    );
  }
}

class Stock {
  String name, unit, quant, amount;

  Stock(Chart chart) {
    this.name = chart.result[0].meta.symbol;
    this.unit = unit;
    this.quant = quant;
    this.amount = amount;
  }
}

class Business {
  //https://query1.finance.yahoo.com/v1/finance/quoteType/?symbol=ITUB4.SA
  //https://query1.finance.yahoo.com/v8/finance/chart/ITUB4.SA?interval=1d

  Future<Chart> fetchPost() async {
    final response = await http.get(
        'https://query1.finance.yahoo.com/v8/finance/chart/ITUB4.SA?interval=1d');

    return Chart.fromJson(json.decode(response.body)['chart']);
  }
}

class Chart {
  List<Result> result;
  String error;

  Chart({this.result, this.error});

  factory Chart.fromJson(Map<String, dynamic> json) {
    return Chart(
        result:
            (json['result'] as List).map((i) => Result.fromJson(i)).toList(),
        error: json['error']);
  }
}

class Result {
  Meta meta;
  Indicators indicators;

  Result({this.meta, this.indicators});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
        meta: Meta.fromJson(json['meta']),
        indicators: Indicators.fromJson(json['indicators']));
  }
}

class Meta {
  String symbol;

  Meta({this.symbol});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(symbol: json['symbol']);
  }
}

class Indicators {
  List<Quote> quote;

  Indicators({this.quote});

  factory Indicators.fromJson(Map<String, dynamic> json) {
    return Indicators(
        quote: (json['quote'] as List).map((i) => Quote.fromJson(i)).toList());
  }
}

class Quote {
  List<double> high;
  List<double> close;
  List<double> low;
  List<double> open;

  Quote({this.high, this.close, this.low, this.open});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
        high: json['high'].cast<double>(),
        close: json['close'].cast<double>(),
        low: json['low'].cast<double>(),
        open: json['open'].cast<double>());
  }
}
