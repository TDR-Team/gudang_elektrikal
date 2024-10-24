import 'package:cloud_firestore/cloud_firestore.dart';

class Component {
  final String id;
  final int? numberRack;
  final int? level;
  final String name;
  final String imgUrl;
  final String description;
  final int stock;
  final String unit;

  Component({
    required this.id,
    this.numberRack,
    this.level,
    required this.name,
    required this.imgUrl,
    required this.description,
    required this.stock,
    required this.unit,
  });

  factory Component.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Component(
      id: doc.id,
      numberRack: data['numberRack'] ?? 0,
      level: data['numberDrawer'] ?? 0,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      stock: data['stock'] ?? 0,
      unit: data['unit'] ?? '',
    );
  }

  factory Component.fromMap(Map<String, dynamic> data) {
    return Component(
      id: data['id'] ?? '',
      numberRack: data['numberRack'] ?? 0,
      level: data['numberDrawer'] ?? 0,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      stock: data['stock'] ?? 0,
      unit: data['unit'] ?? '',
    );
  }
}

final listDummyComponents = [
  Component(
    id: "1",
    numberRack: 1,
    level: 1,
    name: 'Obeng',
    imgUrl: 'imgUrl',
    description: 'description',
    stock: 20,
    unit: 'Pcs',
  ),
  Component(
    id: "2",
    numberRack: 1,
    level: 2,
    name: 'Obeng',
    imgUrl: 'imgUrl',
    description: 'description',
    stock: 20,
    unit: 'Pcs',
  ),
  Component(
    id: "3",
    numberRack: 1,
    level: 3,
    name: 'Obeng',
    imgUrl: 'imgUrl',
    description: 'description',
    stock: 20,
    unit: 'Pcs',
  ),
  Component(
    id: "4",
    numberRack: 1,
    level: 4,
    name: 'Obeng',
    imgUrl: 'imgUrl',
    description: 'description',
    stock: 20,
    unit: 'Pcs',
  ),
  Component(
    id: "5",
    numberRack: 1,
    level: 5,
    name: 'Obeng',
    imgUrl: 'imgUrl',
    description: 'description',
    stock: 20,
    unit: 'Pcs',
  ),
  Component(
    id: "6",
    numberRack: 1,
    level: 6,
    name: 'Obeng',
    imgUrl: 'imgUrl',
    description: 'description',
    stock: 20,
    unit: 'Pcs',
  ),
];
