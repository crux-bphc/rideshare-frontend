import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class noRideScreen extends StatelessWidget{
  const noRideScreen({
    super.key
  });

  @override
  Widget build(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No Rides Avaiable. Create a New one",
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          SizedBox(height: 14,),
          TextButton(
            onPressed: () {
              GoRouter.of(context).go(
                '/rides/create'
              );
            }, 
            child: Text(
              "Create Ride", 
            style: TextStyle(
              fontSize: 18,
            ),))
        ],
      ),
    );
  }
}

