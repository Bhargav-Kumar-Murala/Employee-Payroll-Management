import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dbmanager.dart';
import 'employee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Management',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Employee Management'),
      ),
      body: new Container(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              Expanded(
                child: FutureBuilder(
                  future: SQLiteDbProvider.db.getemployees(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      SingleChildScrollView dataTable(
                          List<Employee> employees) {
                        return SingleChildScrollView(
                          child: DataTable(
                            columns: [
                              DataColumn(
                                label: Text('ID'),
                              ),
                              DataColumn(
                                label: Text('NAME'),
                              ),
                              DataColumn(
                                label: Text('DEPT'),
                              ),
                              DataColumn(
                                label: Text('SALARY(A)'),
                              )
                            ],
                            rows: employees
                                .map(
                                  (employee) => DataRow(cells: [
                                    DataCell(Text('${employee.id}')),
                                    DataCell(Text('${employee.name}'),
                                        onTap: () {
                                      {
                                        Future<void> _createPDF() async {
                                          PdfDocument document = PdfDocument();

                                          document.pages.add().graphics.drawString(
                                              '''PAYSLIP \n\nEmployee Id: ${employee.id} \nEmployee Name: ${employee.name} \nDepartment: ${employee.dept} \nSalary Date: ${employee.dos} \nSalary(M): Rs. ${employee.salm} \nSalary(A): Rs. ${employee.salm * 12}''',
                                              PdfStandardFont(
                                                  PdfFontFamily.helvetica, 20),
                                              brush: PdfSolidBrush(
                                                  PdfColor(0, 0, 0)),
                                              bounds: Rect.fromLTWH(
                                                  0, 0, 500, 200));

                                          List<int> bytes = document.save();

                                          document.dispose();

                                          final directory =
                                              await getExternalStorageDirectory();

                                          final path = directory.path;

                                          File file = File('$path/Payslip.pdf');

                                          await file.writeAsBytes(bytes,
                                              flush: true);

                                          OpenFile.open('$path/Payslip.pdf');
                                        }

                                        @override
                                        Widget pdfButton = FlatButton(
                                          child: Text("Show Payslip"),
                                          onPressed: _createPDF,
                                        );

                                        @override
                                        Widget closeButton = FlatButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        );

                                        AlertDialog alert = AlertDialog(
                                          title: Text("${employee.name}"),
                                          content: Text(
                                            '''Employee Id: ${employee.id} \nEmployee Name: ${employee.name} \nDepartment: ${employee.dept} \nSalary Date: ${employee.dos} \nSalary(M): Rs. ${employee.salm} \nSalary(A): Rs. ${employee.salm * 12}''',
                                          ),
                                          actions: [
                                            pdfButton,
                                            closeButton,
                                          ],
                                        );

                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      }
                                    }),
                                    DataCell(Text('${employee.dept}')),
                                    DataCell(Text('${employee.salm * 12}')),
                                  ]),
                                )
                                .toList(),
                          ),
                        );
                      }

                      return dataTable(snapshot.data);
                    }

                    if (null == snapshot.data || snapshot.data.length == 0) {
                      return Text("No Data Found");
                    }

                    return CircularProgressIndicator();
                  },
                ),
              ),
            ]),
      ),
    );
  }
}
