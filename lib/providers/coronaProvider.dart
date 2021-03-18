import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/question.dart';
import 'package:covid_app/models/user_summary.dart';
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

  @override
  Future<UserSummary> fetchUserSummary(String userId) {
    return Paths.firestoreDb
        .collection('userSummary')
        .doc(userId)
        .get()
        .then((snapshot) => UserSummary.fromJson(snapshot.data()));
  }

  @override
  Future<void> updateUserSummary(UserSummary userSummary) {
    return Paths.firestoreDb
        .collection('userSummary')
        .doc(userSummary.userId)
        .set(userSummary.toJson(), SetOptions(merge: true));
  }
}
