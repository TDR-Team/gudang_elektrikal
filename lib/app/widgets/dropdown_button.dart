import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../common/theme/font.dart';
import '../utils/logging.dart';

class DropDown<T> extends StatelessWidget {
  final String? hintText;
  final List<T>? listElement;
  final T? selectedItem;
  final ValueChanged<T?>? onChange;
  final String Function(T?)? itemAsString;
  final String? Function(T?)? validator;
  final String? Function(T?)? onAddItem;
  final Widget Function(BuildContext, T?, bool)? itemBuilder;
  final bool showSearchBox;
  final Color? fillColor;
  final BorderSide? borderSide;

  const DropDown({
    super.key,
    required this.listElement,
    this.hintText,
    this.selectedItem,
    this.onChange,
    this.onAddItem,
    this.itemAsString,
    this.validator,
    this.itemBuilder,
    this.showSearchBox = true,
    this.fillColor,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    // Create a new list that includes the "Tambah Rak Baru" option
    List<T> updatedListElement = List.from(listElement ?? []);
    final addNewRackItem = 'Tambah Rak Baru' as T;
    updatedListElement.add(addNewRackItem);

    return DropdownSearch<T>(
      items: updatedListElement,
      selectedItem: selectedItem,
      itemAsString: (item) {
        // Check if the item is the "Tambah Rak Baru" option
        if (item == addNewRackItem) {
          return 'Tambah Rak Baru';
        }
        return itemAsString?.call(item) ?? item.toString();
      },
      onChanged: onAddItem,
      validator: validator,
      autoValidateMode: AutovalidateMode.always,
      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: regularText12,
        dropdownSearchDecoration: InputDecoration(
          fillColor: fillColor ?? Colors.grey[200],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: borderSide ?? BorderSide.none,
          ),
          hintText: hintText,
        ),
      ),
      popupProps: PopupProps.menu(
        menuProps: MenuProps(
          borderRadius: BorderRadius.circular(16),
        ),
        showSearchBox: showSearchBox,
        fit: FlexFit.loose,
        searchFieldProps: TextFieldProps(
          style: regularText12,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        loadingBuilder: (context, searchEntry) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Menunggu..',
              textAlign: TextAlign.center,
              style: semiBoldText12,
            ),
          );
        },
        emptyBuilder: (context, searchEntry) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Data tidak ditemukan',
              textAlign: TextAlign.center,
              style: semiBoldText12,
            ),
          );
        },
        itemBuilder: itemBuilder ??
            (context, item, isSelected) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        item == addNewRackItem
                            ? 'Tambah Rak Baru'
                            : item.toString(),
                        style: regularText12,
                      ),
                    ),
                  ),
                  if (item != addNewRackItem)
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                  leading: const Icon(Icons.edit),
                                  title: const Text('Edit'),
                                  onTap: () {
                                    // Handle edit functionality here
                                    log.i('Edit pressed for $item');
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Delete'),
                                  onTap: () {
                                    // Handle delete functionality here
                                    log.i('Delete pressed for $item');
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_vert),
                    ),
                ],
              );
            },
        listViewProps: const ListViewProps(
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
