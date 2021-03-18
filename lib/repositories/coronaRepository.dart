import 'package:covid_app/models/question.dart';
import 'package:covid_app/models/user_summary.dart';
import 'package:covid_app/providers/coronaProvider.dart';
import 'package:covid_app/providers/provider.dart';

class CoronaRepository {
  BaseCoronaProvider _coronaProvider = CoronaProvider();

  Future<List<Question>> fetchSelfTestQuestions() {
    return _coronaProvider.fetchSelfTestQuestions();
  }

  Future<UserSummary> fetchUserSummary(String userId) {
    return _coronaProvider.fetchUserSummary(userId);
  }

  Future<void> updateUserSummary(UserSummary userSummary) {
    return _coronaProvider.updateUserSummary(userSummary);
  }
}
