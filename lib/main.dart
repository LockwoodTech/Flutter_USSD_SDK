import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hover SDK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'hover SDK'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  static const _hover = const MethodChannel('kikoba.co.tz/hover');
  String _ActionResponse = 'Waiting for Response...';
  Future<dynamic> sendMoney(var phoneNumber, amount) async {
    var sendMap = <String, dynamic>{
      'phoneNumber': "phoneNumber",
      'amount': amount,
    };
// response waits for result from java code
    String response = "";
    try {
      final String result = await _hover.invokeMethod('sendMoney', sendMap);
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    _ActionResponse = response;
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildNumberTextField() {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(10),
            ],
            controller: phoneNumberController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter phone number';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Namba ya simu',
              prefix: Text('+255'),
              suffixIcon: Icon(Icons.dialpad),
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ));
    }

    Widget _buildAmountTextField() {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: TextFormField(
            controller: amountController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter amount';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefix: Text('Tsh'),
              labelText: 'Kiasi',
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ));
    }

    Widget _buildTuma() {
      return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildNumberTextField(),
              _buildAmountTextField(),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    sendMoney(
                        phoneNumberController.text, amountController.text);
                  }
                },
                child: Text("send Money"),
              ),
              Text(_ActionResponse),
            ],
          ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildTuma(),
          ],
        ),
      ),
    );
  }
}
