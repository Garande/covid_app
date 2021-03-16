import 'package:covid_app/models/question.dart';
import 'package:covid_app/providers/provider.dart';
import 'package:covid_app/utils/Paths.dart';

class CoronaProvider extends BaseCoronaProvider {
  @override
  Future<List<Question>> fetchSelfTestQuestions() {
    return Paths.firestoreDb
        .collection('/MAIN/ACTIVITIES/SELF_CHECKUP_QUESTIONS')
        .get()
        .then((snapshot) =>
            snapshot.docs.map((doc) => Question.fromJson(doc.data())).toList());
  }
}
