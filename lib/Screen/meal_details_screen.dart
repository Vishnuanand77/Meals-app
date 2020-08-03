import 'package:flutter/material.dart';

import '../dummy_data.dart';

class MealsDetailsScreen extends StatelessWidget {
  static const routeName = '/MealsDetails';

  final Function toggleFavs;
  final Function isMealFav;

  MealsDetailsScreen(this.toggleFavs, this.isMealFav);

  Widget buildSectionTitle(BuildContext context, String text) {
    //Builder method to avoid code duplication
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      height: 220,
      width: 350,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealID = ModalRoute.of(context).settings.arguments as String;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) => meal.id == mealID);
    return Scaffold(
      appBar: AppBar(
        title: Text('${selectedMeal.title}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                selectedMeal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            buildSectionTitle(context, 'Ingredients'),
            buildContainer(
              ListView.builder(
                itemBuilder: (context, index) => Card(
                  color: Theme.of(context).accentColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    child: Text(selectedMeal.ingredients[index]),
                  ),
                ),
                itemCount: selectedMeal.ingredients.length,
              ),
            ),
            buildSectionTitle(context, 'Steps'),
            buildContainer(ListView.builder(
              itemBuilder: (context, index) => Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        '${(index + 1)}',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors
                          .pinkAccent, //Color.fromRGBO(221, 180, 170, 0.8),
                    ),
                    title: Text(
                      selectedMeal.steps[index],
                    ),
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                ],
              ),
              itemCount: selectedMeal.steps.length,
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          isMealFav(mealID) ? Icons.star : Icons.star_border,
        ),
        onPressed: () => toggleFavs(mealID),
      ),
    );
  }
}

// padding: const EdgeInsets.fromLTRB(100, 60, 0, 0),
//         child: FloatingActionButton.extended(
//           icon: Icon(
//             Icons.check_circle,
//             color: Colors.white,
//           ),
//           label: Text(
//             'Mark read',
//             style: TextStyle(
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: Colors.pink,
//           onPressed: () {
//             Navigator.of(context).pop(mealID);
//           },
//         ),
//floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
