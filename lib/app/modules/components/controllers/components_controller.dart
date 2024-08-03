import 'package:cloud_functions/cloud_functions.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gudang_elektrikal/app/modules/components/views/list_components_view.dart';
import 'package:gudang_elektrikal/app/data/model/component.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ComponentsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  var rackNames = <String>[].obs;
  var listDrawers = <String>[].obs;
  var rackName = ''.obs;
  var drawers = <String, List<Component>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRackNames();
  }

  void fetchRackNames() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('components').get();
      List<String> names = querySnapshot.docs.map((doc) => doc.id).toList();
      rackNames.assignAll(names);
    } catch (e) {
      print("Error fetching rack names: $e");
    }
  }

  void fetchDrawers(String rackName) async {
    try {
      // Clear previous data
      List<String> drawerNames = [];
      drawers.clear();

      // Call the Firebase Function to list subcollections
      HttpsCallable callable = _functions.httpsCallable('listSubcollections');
      final result = await callable.call({'path': 'components/$rackName'});

      List<dynamic> subcollections = result.data;
      for (var collectionName in subcollections) {
        drawerNames.add(collectionName);
        CollectionReference collectionRef = _firestore
            .collection('components')
            .doc(rackName)
            .collection(collectionName);

        QuerySnapshot componentsSnapshot = await collectionRef.get();
        List<Component> components = componentsSnapshot.docs
            .map((doc) => Component.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        drawers[collectionName] = components;
      }

      listDrawers.assignAll(drawerNames);
    } catch (e) {
      print("Error fetching drawers: $e");
    }
  }

  void onChangedRackName(String? value) {
    if (value != null) {
      rackName.value = value;
      fetchDrawers(value);
    }
  }

  void onDrawerClicked(String rackName, String drawerName) {
    Get.to(
      () => const ListComponentsView(),
      arguments: {
        "rackName": rackName,
        "drawerName": drawerName,
      },
    );
  }
}
