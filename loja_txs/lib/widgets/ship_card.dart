import 'package:flutter/material.dart';
class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Calculo frete",
          textAlign: TextAlign.start,
          style:
              TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
        ),
        leading: Icon(Icons.location_on),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu CEP"
              ),
              initialValue: "",
              onFieldSubmitted: (text){
                
              },
            ),
            
          )
        ],
      ),
      
    );
  }
}