import 'package:to_faminto_client/models/filter.dart';

mixin FilterLogic {
  List<Filter> _appliedFilters = [];
  List<Filter> get appliedFilters => _appliedFilters;

  void toggleFilter(Filter filter) {
    _appliedFilters.contains(filter)
        ? _appliedFilters.remove(filter)
        : _appliedFilters.add(filter);
  }

  void clearAppliedFilters() {
    _appliedFilters.clear();
  }
}
