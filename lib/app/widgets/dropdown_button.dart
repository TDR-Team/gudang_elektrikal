import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../common/theme/font.dart';

class DropDown<T> extends StatelessWidget {
  final String? hintText;
  final List<T>? listElement;
  final T? selectedItem;
  final ValueChanged<T?>? onChange;
  final String Function(T)? itemAsString;
  final String? Function(T?)? validator;
  final Widget Function(BuildContext, T, bool, bool)? itemBuilder;
  final Widget Function(BuildContext, T?)? dropdownBuilder;
  final bool showSearchBox;
  final Color? fillColor;
  final BorderSide? borderSide;
  final bool enabled;
  final bool autoValidateAlways;
  final bool Function(T, T)? compareFn;

  const DropDown({
    super.key,
    required this.listElement,
    this.hintText,
    this.selectedItem,
    this.onChange,
    this.itemAsString,
    this.validator,
    this.itemBuilder,
    this.dropdownBuilder,
    this.showSearchBox = true,
    this.fillColor,
    this.borderSide,
    this.enabled = true,
    this.autoValidateAlways = true,
    this.compareFn,
  });

  @override
  Widget build(BuildContext context) {
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: borderSide ?? BorderSide.none,
    );

    return DropdownSearch<T>(
      enabled: enabled,
      selectedItem: selectedItem,
      items: (filter, loadProps) => listElement ?? <T>[],
      itemAsString: itemAsString,
      compareFn: compareFn,
      onSelected: onChange,
      validator: validator,
      dropdownBuilder: dropdownBuilder,
      autoValidateMode: autoValidateAlways
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      decoratorProps: DropDownDecoratorProps(
        baseStyle: mediumText14.copyWith(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: regularText12.copyWith(color: Colors.grey.shade600),
          filled: true,
          fillColor: fillColor ?? Colors.grey[200],
          border: outlineBorder,
          enabledBorder: outlineBorder,
          focusedBorder: outlineBorder,
          errorBorder: outlineBorder.copyWith(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          focusedErrorBorder: outlineBorder.copyWith(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: showSearchBox,
        fit: FlexFit.loose,
        menuProps: const MenuProps(backgroundColor: Colors.white),
        searchFieldProps: TextFieldProps(
          style: regularText12.copyWith(color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Cari...',
            hintStyle: regularText12.copyWith(color: Colors.grey.shade600),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
        loadingBuilder: (context, searchEntry) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 8, top: 8),
            child: Text(
              'Menunggu..',
              textAlign: TextAlign.center,
              style: semiBoldText12.copyWith(color: Colors.black),
            ),
          );
        },
        emptyBuilder: (context, searchEntry) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 8, top: 8),
            child: Text(
              'Data tidak ditemukan',
              textAlign: TextAlign.center,
              style: semiBoldText12.copyWith(color: Colors.black),
            ),
          );
        },
        itemBuilder:
            itemBuilder ??
            (context, item, isDisabled, isSelected) {
              return Container(
                padding: const EdgeInsets.all(12),
                color: isSelected ? Colors.grey[100] : null,
                child: Text(
                  itemAsString != null ? itemAsString!(item) : item.toString(),
                  style: regularText12.copyWith(color: Colors.black),
                ),
              );
            },
        listViewProps: const ListViewProps(
          padding: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
