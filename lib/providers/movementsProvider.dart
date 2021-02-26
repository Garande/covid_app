import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_app/models/user_movement.dart';
import 'package:covid_app/providers/provider.dart';
import 'package:covid_app/utils/Paths.dart';

final String movementsCollectionsPath = '';

class MovementsProvider extends BaseMovementsProvider {
  @override
  Future<UserMovement> fetchUserLastMovement(String userId) {
    // TODO: implement fetchUserLastMovement
    throw UnimplementedError();
  }

  @override
  Future<List<UserMovement>> fetchUserMovements(String userId) {
    // TODO: implement fetchUserMovements
    throw UnimplementedError();
  }

  @override
  Future<void> saveUserMovement(UserMovement userMovement) {
    if (userMovement.id == null || userMovement.id.isEmpty) {
      userMovement.id = Paths.generateFirestoreDbKey(
          [userMovement.userId, 'MOV'],
          new DateTime.now().millisecondsSinceEpoch);
    }
    return Paths.firestoreDb
        .collection(movementsCollectionsPath)
        .doc(userMovement.id)
        .set(userMovement.toJson(), SetOptions(merge: true));
  }

  @override
  Future<List<UserMovement>> fetchUserMovementsBetween(
      String userId, DateTime dateTimeFrom, DateTime dateTimeTo) {
    return Paths.firestoreDb
        .collection(movementsCollectionsPath)
        .where('userId', isEqualTo: userId)
        .where('creationDateTimeMillis',
            isGreaterThanOrEqualTo: dateTimeFrom.millisecondsSinceEpoch)
        .where('creationDateTimeMills',
            isLessThanOrEqualTo: dateTimeTo.millisecondsSinceEpoch)
        .get()
        .then(
          (snapshot) => snapshot.docs
              .map((doc) => UserMovement.fromMap(doc.data()))
              .toList(),
        );
  }
}
