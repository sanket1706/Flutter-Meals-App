import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersProviderNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersProviderNotifier()
      : super(
          {
            Filter.glutenFree: false,
            Filter.lactoseFree: false,
            Filter.vegetarian: false,
            Filter.vegan: false,
          },
        );

  void setFilters(Map<Filter, bool> choosenFilters) {
    state = choosenFilters;
  }

  void setFilter(Filter filter, bool isChecked) {
    state = {...state, filter: isChecked};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersProviderNotifier, Map<Filter, bool>>((ref) {
  return FiltersProviderNotifier();
});

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final availableFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (availableFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (availableFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (availableFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (availableFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
