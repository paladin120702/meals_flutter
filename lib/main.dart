import 'package:flutter/material.dart';
import 'utills/app_routes.dart';
import 'screens/categories_meals.dart';
import 'screens/meal_detail.dart';
import 'screens/tabs.dart';
import 'screens/settings.dart';
import 'models/meal.dart';
import 'data/dummy_data.dart';
import 'models/filters.dart';

void main() => runApp(const Meals());

class Meals extends StatefulWidget {
  const Meals({super.key});

  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  Filters filters = Filters();
  List<Meal> _availableMeals = dummyMeals;
  List<Meal> _favoriteMeals = [];

  void _filterMeals(Filters filters) {
    setState(() {
      this.filters = filters;
      _availableMeals = dummyMeals.where((meal) {
        final filterGluten = filters.isGlutenFree && !meal.isGlutenFree;
        final filterLactose = filters.isLactoseFree && !meal.isLactoseFree;
        final filterVegan = filters.isVegan && !meal.isVegan;
        final filterVegetarian = filters.isVegetarian && !meal.isVegetarian;
        return !filterGluten &&
            !filterLactose &&
            !filterVegan &&
            !filterVegetarian;
      }).toList();
    });
  }

  void _toggleFavorite(Meal meal) {
    setState(() {
      _favoriteMeals.contains(meal)
          ? _favoriteMeals.remove(meal)
          : _favoriteMeals.add(meal);
    });
  }

  bool _isFavorite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        primaryColor: Colors.pink,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: const TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
              ),
            ),
      ),
      routes: {
        AppRoutes.HOME: (ctx) => Tabs(_favoriteMeals),
        AppRoutes.CATEGORIES_MEALS: (ctx) => CategoriesMeals(_availableMeals),
        AppRoutes.MEAL_DETAIL: (ctx) =>
            MealDetail(_toggleFavorite, _isFavorite),
        AppRoutes.SETTINGS: (ctx) => Settings(_filterMeals, filters),
      },
    );
  }
}
