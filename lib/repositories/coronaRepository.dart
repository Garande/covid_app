import 'package:covid_app/models/question.dart';
import 'package:covid_app/providers/coronaProvider.dart';
import 'package:covid_app/providers/provider.dart';

class CoronaRepository {
  BaseCoronaProvider _coronaProvider = CoronaProvider();

  Future<List<Question>> fetchSelfTestQuestions() {
    return _coronaProvider.fetchSelfTestQuestions();
  }
}
