import 'package:flutter/material.dart';
import 'package:mealsApp/Screen/errorScreen.dart';
import 'package:mealsApp/Screen/filters_screen.dart';
import 'package:mealsApp/Screen/meal_details_screen.dart';
import 'package:mealsApp/Screen/tab_Screen.dart';
import 'package:flutter/services.dart';
import 'package:mealsApp/dummy_data.dart';
import 'package:mealsApp/models/meal.dart';

import 'Screen/categories_screen.dart';
import 'Screen/CategoryMealsScreen.dart';
import './dummy_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegetarian': false,
    'vegan': false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS;
  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        if (_filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegetarian'] && !meal.isVegetarian) {
          return false;
        }
        if (_filters['vegan'] && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavs(String mealId) {
    final isExistingIndex =
        _favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (isExistingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(isExistingIndex);
      });
    } else {
      setState(() {
        _favoriteMeals.add(
          DUMMY_MEALS.firstWhere((meal) => meal.id == mealId),
        );
      });
    }
  }

  bool _isMealFavorite(String mealId) {
    //returns true if meal is present
    return _favoriteMeals.any((meal) => meal.id == mealId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyText2: TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              headline6: TextStyle(
                fontSize: 22,
                fontFamily: 'RobotoCondensed',
                // fontWeight: FontWeight.bold,
              ),
            ),
      ),
      initialRoute: '/', //Having an initial route (can be any other page)
      routes: {
        '/': (ctx) => TabScreen(_favoriteMeals), //Route for home page
        CategoryMealsScreen.routeName: (ctx) =>
            CategoryMealsScreen(_availableMeals), //Route for Meals screen page
        MealsDetailsScreen.routeName: (ctx) =>
            MealsDetailsScreen(_toggleFavs, _isMealFavorite),
        FilterScreen.routeName: (ctx) => FilterScreen(_filters, _setFilters),
      },
      //If there is no predefined route, onGenerate route makes one and takes us to a
      //default page, like an error page or any page we desire.
      // onGenerateRoute: (settings) {
      //   print(settings.arguments);
      //   return MaterialPageRoute(
      //     builder: (ctx) => ErrorScreen(),
      //   );
      // },

      //This is done if flutter has tried all methods to generate a new page and now it doesn't
      //know what to do. As a last resort, developers use this to throw an error page so that
      //the app does not crash.
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => ErrorScreen(),
        );
      },
    );
  }
}
