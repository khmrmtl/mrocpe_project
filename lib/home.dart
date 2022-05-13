import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mrocpe_project/data_dao.dart';
import 'package:mrocpe_project/data_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  final MessageDao dao = MessageDao();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Stream<DatabaseEvent> stream;
  int _value = 0;
  int _waterLevel = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = widget.dao.getData();

    stream.listen(_activateListener);
  }

  _activateListener(DatabaseEvent event) {
    Data _readings = Data.fromJson(event.snapshot.value as Map);
    setState(() {
      if (_readings.value >= 390) {
        _waterLevel = 3;
      } else if (_readings.value >= 290.0) {
        _waterLevel = 2;
      } else if (_readings.value >= 200.0) {
        _waterLevel = 1;
      } else {
        _waterLevel = 0;
      }
      _value = _readings.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5.0,
                color: Colors.blueAccent,
                child: SizedBox.expand(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40.0,
                      ),
                      const Text(
                        'MROCPE Project',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Column(
                        children: const [
                          Text(
                            'Bistoguey, Jones',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Motal, Khmer ',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Tomilas, Christopher',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Reading',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$_value',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 60.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Water Level',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            ListTile(
                              leading: Text(
                                'HIGH',
                                style: TextStyle(
                                  color: _waterLevel == 3
                                      ? Colors.red
                                      : Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: Text(
                                "Heater turned on",
                                style: TextStyle(
                                  color: _waterLevel == 3
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              tileColor:
                                  _waterLevel == 3 ? Colors.white : Colors.grey,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              leading: Text(
                                'MEDIUM',
                                style: TextStyle(
                                  color: _waterLevel == 2
                                      ? Colors.orange
                                      : Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: Text(
                                "Plastic sheet pulled",
                                style: TextStyle(
                                  color: _waterLevel == 2
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              tileColor:
                                  _waterLevel == 2 ? Colors.white : Colors.grey,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              leading: Text(
                                'LOW',
                                style: TextStyle(
                                  color: _waterLevel == 1
                                      ? Colors.yellow
                                      : Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: Text(
                                "Net pulled",
                                style: TextStyle(
                                  color: _waterLevel == 1
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              tileColor:
                                  _waterLevel == 1 ? Colors.white : Colors.grey,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            ListTile(
                              leading: Text(
                                'EMPTY',
                                style: TextStyle(
                                  color: _waterLevel == 0
                                      ? Colors.green
                                      : Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              title: Text(
                                "No action done",
                                style: TextStyle(
                                  color: _waterLevel == 0
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              tileColor:
                                  _waterLevel == 0 ? Colors.white : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              right: 0.0,
              child: Image.asset('assets/images/topher.png'),
            ),
          ],
        ),
      ),
    );
  }
}
