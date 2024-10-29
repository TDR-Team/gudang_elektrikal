import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import '../common/theme/font.dart';

class DropDown<T> extends StatelessWidget {
  final String? hintText;
  final List<T>? listElement;
  final T? selectedItem;
  final ValueChanged<T?>? onChange;
  final String Function(T?)? itemAsString;
  final String? Function(T?)? validator;
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
    this.itemAsString,
    this.validator,
    this.itemBuilder,
    this.showSearchBox = true,
    this.fillColor,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: listElement ?? [],
      selectedItem: selectedItem,
      itemAsString: itemAsString,
      onChanged: onChange,
      validator: validator,
      autoValidateMode: AutovalidateMode.always,

      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: mediumText14,
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
          backgroundColor: Colors.white,
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
              return Container(
                padding: const EdgeInsets.all(12),
                child: Text(
                  item.toString(),
                  style: regularText12,
                ),
              );
            },
        listViewProps: const ListViewProps(
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      // clearButtonProps: const ClearButtonProps(
      //   icon: Icon(Icons.clear, size: 22),
      //   isVisible: true,
      // ),
    );
  }
}
