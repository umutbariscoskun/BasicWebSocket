import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: WebsocketDemo()));
}

class WebsocketDemo extends StatefulWidget {
  const WebsocketDemo({super.key});

  @override
  State<WebsocketDemo> createState() => _WebsocketDemoState();
}

class _WebsocketDemoState extends State<WebsocketDemo> {
  String btcUsdtPrice = "0.00";
  final channel = IOWebSocketChannel.connect(
      'wss://stream.binance.com:9443/ws/btcusdt@trade');

  @override
  void initState() {
    super.initState();
    streamListener();
  }

  void streamListener() {
    channel.stream.listen((message) {
      Map<String, dynamic> getData = jsonDecode(message);
      setState(() {
        btcUsdtPrice = formatPrice(getData['p']);
      });
    });
  }

  String formatPrice(String price) {
    try {
      double priceDouble = double.parse(price);
      return priceDouble.toStringAsFixed(2);
    } catch (e) {
      return "0.00";
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "BTC/USDT: \$$btcUsdtPrice",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                    fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
