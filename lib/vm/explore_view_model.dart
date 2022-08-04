import 'package:webmfetch/sources/4ch.dart';
import 'package:webmfetch/vm/shared_view_model.dart';

class ExploreViewModel extends SharedViewModel {
  FourChanAPI? fourChanAPI;
  List<Threads> catalog = <Threads>[];

  @override
  init() async {
    fourChanAPI = FourChanAPI();
    await fourChanAPI?.fetchCatalog();
    catalog = fourChanAPI!.catalog;
    notifyListeners();
  }

  refreshCatalog() async {
    await fourChanAPI?.fetchCatalog();
    catalog = fourChanAPI!.catalog;
    notifyListeners();
  }
}
