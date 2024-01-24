import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TipPercentage { five, ten, fifteen, twenty }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Propinas',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorScheme: lightDynamic,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: darkDynamic,
          ),
          themeMode: ThemeMode.system,
          home: const MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  double _total = 0.0;
  TipPercentage _tipPercentage = TipPercentage.ten;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propinas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                setState(() => _total = double.parse(value));
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Total de la cuenta',
              ),
            ),
            const SizedBox(height: 20.0),
            SegmentedButton(
              segments: const <ButtonSegment<TipPercentage>>[
                ButtonSegment(
                  value: TipPercentage.five,
                  label: Text('5%'),
                  icon: Icon(Icons.attach_money),
                ),
                ButtonSegment(
                  value: TipPercentage.ten,
                  label: Text('10%'),
                  icon: Icon(Icons.attach_money),
                ),
                ButtonSegment(
                  value: TipPercentage.fifteen,
                  label: Text('15%'),
                  icon: Icon(Icons.attach_money),
                ),
                ButtonSegment(
                  value: TipPercentage.twenty,
                  label: Text('20%'),
                  icon: Icon(Icons.attach_money),
                ),
              ],
              selected: <TipPercentage>{_tipPercentage},
              onSelectionChanged: (Set<TipPercentage> value) {
                setState(() => _tipPercentage = value.first);
              },
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      final double tip =
                          _total * (_tipPercentage.index + 1) * 0.05;
                      final double total = _total + tip;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Propinas'),
                            content: Text(
                              'Propina: \$ ${tip.toStringAsFixed(2)}\n'
                              'Total a pagar: \$ ${total.toStringAsFixed(2)}',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cerrar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calcular'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
