class Drawer {
  final int id;
  final int numberRack;
  final int numberDrawer;

  final String name;
  final String photo;
  final String description;
  final int stock;

  Drawer({
    required this.id,
    required this.numberRack,
    required this.numberDrawer,
    required this.name,
    required this.photo,
    required this.description,
    required this.stock,
  });
}

final listDummyDrawer = [
  Drawer(
    id: 1,
    numberRack: 1,
    numberDrawer: 1,
    name: 'Obeng',
    photo: 'photo',
    description: 'description',
    stock: 20,
  ),
  Drawer(
    id: 2,
    numberRack: 1,
    numberDrawer: 2,
    name: 'Obeng',
    photo: 'photo',
    description: 'description',
    stock: 20,
  ),
  Drawer(
    id: 3,
    numberRack: 1,
    numberDrawer: 3,
    name: 'Obeng',
    photo: 'photo',
    description: 'description',
    stock: 20,
  ),
  Drawer(
    id: 4,
    numberRack: 1,
    numberDrawer: 5,
    name: 'Obeng',
    photo: 'photo',
    description: 'description',
    stock: 20,
  ),
  Drawer(
    id: 6,
    numberRack: 1,
    numberDrawer: 6,
    name: 'Obeng',
    photo: 'photo',
    description: 'description',
    stock: 20,
  ),
];
