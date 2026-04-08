import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget{
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
      ),
      body : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Total Balance",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 10),
            const Text( " 20,000",
            style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children:[
                _buildButton(context, "Add Salary"),
                _buildButton(context, "Add Expenses"),
              ],
            ),

            const SizedBox(height: 10),

            const ListTile(
              title: Text("Food"),
              trailing: Text("200"),
            ),

            const ListTile(
              title: Text("Travel"),
              trailing: Text("500"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(text),
    );
  }
}