import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dash_board/core/entities/product_entity.dart';
import 'package:fruit_hub_dash_board/core/helper_fun/formatters.dart';
import 'package:fruit_hub_dash_board/core/utils/app_colors.dart';
import 'package:fruit_hub_dash_board/core/utils/app_styles.dart';
import 'package:fruit_hub_dash_board/core/widgets/custom_alert_dialogs.dart';
import 'package:fruit_hub_dash_board/core/widgets/custom_button.dart';
import 'package:fruit_hub_dash_board/core/widgets/custom_loading_indicator.dart';
import 'package:fruit_hub_dash_board/core/widgets/custom_text_field.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/manger/add_product_cubit/add_product_cubit.dart';
import 'package:fruit_hub_dash_board/features/add_product/presentation/views/widgets/image_field.dart';
import 'package:fruit_hub_dash_board/features/products/presentation/manger/products_cubit/products_cubit.dart';

/// One form for add + edit. It writes every field the client app reads
/// (Arabic + English names, discount, unit, category, …).
class AddProductViewBody extends StatefulWidget {
  const AddProductViewBody({super.key, this.product});
  final ProductEntity? product;

  @override
  State<AddProductViewBody> createState() => _AddProductViewBodyState();
}

class _AddProductViewBodyState extends State<AddProductViewBody> {
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  late String name, nameEn, code, description, descriptionEn, unit;
  late double price;
  double? oldPrice;
  late int quantity, expirationMonths, numberOfCalories;

  late String category = widget.product?.category ?? kCategories.keys.first;
  late bool isFeatured = widget.product?.isFeatured ?? false;
  late bool isOrganic = widget.product?.isOrganic ?? false;
  ({Uint8List bytes, String name})? image;

  bool get isEdit => widget.product != null;

  static String? _number(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return num.tryParse(v.trim()) == null ? 'اكتب رقم صحيح' : null;
  }

  String? _initial(num? v) => v == null
      ? null
      : (v == v.roundToDouble() ? v.toInt().toString() : v.toString());

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return BlocListener<AddProductCubit, AddProductState>(
      listener: (context, state) {
        if (state is AddProductFailure) {
          CustomAlertDialog.error(
            context: context,
            title: 'حصلت مشكلة',
            desc: state.message,
            btnOkText: 'تمام',
          ).show();
        } else if (state is AddProductSuccess) {
          context.read<ProductsCubit>().upsert(state.product);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.green1500,
              content: Text(
                isEdit
                    ? 'تم حفظ التعديلات ✓'
                    : 'تمت إضافة "${state.product.name}" ✓',
              ),
            ),
          );
          Navigator.pop(context);
        }
      },
      child: CustomProgressIndicator(
        loading: context.watch<AddProductCubit>().state is AddProductLoading,
        child: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              ImageField(
                currentUrl: p?.imageUrl ?? '',
                onImageSelected: (img) => image = img,
              ),
              _Section(
                title: 'بيانات المنتج',
                icon: Icons.label_rounded,
                children: [
                  CustomTextField(
                    label: 'الاسم بالعربي',
                    hintText: 'مثال: مانجو عويسي',
                    initialValue: p?.name,
                    onSaved: (v) => name = v!.trim(),
                  ),
                  CustomTextField(
                    label: 'الاسم بالإنجليزي',
                    hintText: 'e.g. Owais Mango',
                    initialValue: p?.nameEn,
                    textDirection: TextDirection.ltr,
                    onSaved: (v) => nameEn = v!.trim(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'كود المنتج',
                          hintText: 'FH-120',
                          initialValue: p?.code,
                          textDirection: TextDirection.ltr,
                          onSaved: (v) => code = v!.trim(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _categoryField()),
                    ],
                  ),
                ],
              ),
              _Section(
                title: 'السعر والمخزون',
                icon: Icons.sell_rounded,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'السعر (جنيه)',
                          hintText: '75',
                          initialValue: _initial(p?.price),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: _number,
                          onSaved: (v) => price = double.parse(v!.trim()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'السعر قبل الخصم',
                          hintText: 'اختياري',
                          isRequired: false,
                          initialValue: _initial(p?.oldPrice),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (v) {
                            final err = _number(v);
                            if (err != null || v == null || v.trim().isEmpty) {
                              return err;
                            }
                            return null;
                          },
                          onSaved: (v) => oldPrice = (v == null || v.isEmpty)
                              ? null
                              : double.tryParse(v.trim()),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'الوحدة',
                          hintText: 'كيلو',
                          initialValue: p?.unit ?? 'كيلو',
                          onSaved: (v) => unit = v!.trim(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'الكمية في المخزن',
                          hintText: '100',
                          initialValue: _initial(p?.quantity),
                          keyboardType: TextInputType.number,
                          validator: _number,
                          onSaved: (v) => quantity = int.parse(v!.trim()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _Section(
                title: 'معلومات إضافية',
                icon: Icons.info_rounded,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'الصلاحية (شهور)',
                          hintText: '1',
                          initialValue: _initial(p?.expirationMonths),
                          keyboardType: TextInputType.number,
                          validator: _number,
                          onSaved: (v) =>
                              expirationMonths = int.parse(v!.trim()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          label: 'سعرات / 100 جم',
                          hintText: '60',
                          initialValue: _initial(p?.numberOfCalories),
                          keyboardType: TextInputType.number,
                          validator: _number,
                          onSaved: (v) =>
                              numberOfCalories = int.parse(v!.trim()),
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    label: 'الوصف بالعربي',
                    hintText: 'اكتب وصف قصير يظهر للعميل…',
                    maxLines: 3,
                    initialValue: p?.description,
                    onSaved: (v) => description = v!.trim(),
                  ),
                  CustomTextField(
                    label: 'الوصف بالإنجليزي',
                    hintText: 'Short description for English users…',
                    maxLines: 3,
                    initialValue: p?.descriptionEn,
                    textDirection: TextDirection.ltr,
                    onSaved: (v) => descriptionEn = v!.trim(),
                  ),
                  _SwitchTile(
                    icon: Icons.eco_rounded,
                    title: 'منتج أورجانيك',
                    subtitle: 'هيظهر عليه بادج "100% أورجانيك"',
                    value: isOrganic,
                    onChanged: (v) => setState(() => isOrganic = v),
                  ),
                  _SwitchTile(
                    icon: Icons.star_rounded,
                    title: 'منتج مميز',
                    subtitle: 'يظهر في قسم المميز في الرئيسية',
                    value: isFeatured,
                    onChanged: (v) => setState(() => isFeatured = v),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: _submit,
                text: isEdit ? 'حفظ التعديلات' : 'إضافة المنتج',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'القسم',
          style: AppStyles.bodyXSmallBold.copyWith(
            color: AppColors.grayscale600,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: category,
          borderRadius: BorderRadius.circular(12),
          style: AppStyles.bodySmallsemiBold.copyWith(
            color: AppColors.grayscale950,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xffF9FAFA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffE6E9EA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xffE6E9EA)),
            ),
          ),
          items: [
            for (final e in kCategories.entries)
              DropdownMenuItem(value: e.key, child: Text(e.value)),
          ],
          onChanged: (v) => setState(() => category = v ?? category),
        ),
      ],
    );
  }

  void _submit() {
    if (!isEdit && image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('اختار صورة للمنتج الأول')));
      return;
    }
    if (!formKey.currentState!.validate()) {
      setState(() => autovalidateMode = AutovalidateMode.always);
      return;
    }
    formKey.currentState!.save();
    if (oldPrice != null && oldPrice! <= price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('السعر قبل الخصم لازم يكون أكبر من السعر الحالي'),
        ),
      );
      return;
    }

    final old = widget.product;
    final product = ProductEntity(
      id: old?.id ?? '',
      name: name,
      nameEn: nameEn,
      code: code,
      description: description,
      descriptionEn: descriptionEn,
      price: price,
      oldPrice: oldPrice,
      unit: unit,
      // Keep the English unit for the common case; custom units stay as is.
      unitEn: unit == 'كيلو' ? 'kg' : (old?.unitEn ?? unit),
      category: category,
      imageUrl: old?.imageUrl ?? '',
      isFeatured: isFeatured,
      isOrganic: isOrganic,
      expirationMonths: expirationMonths,
      numberOfCalories: numberOfCalories,
      quantity: quantity,
      // Sales & reviews come from customers, the form never resets them.
      avgRating: old?.avgRating ?? 0,
      ratingCount: old?.ratingCount ?? 0,
      sellingCount: old?.sellingCount ?? 0,
      reviews: old?.reviews ?? const [],
    );
    context.read<AddProductCubit>().save(
      product: product,
      isEdit: isEdit,
      image: image,
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.children,
  });
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffEEF0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.green1500),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppStyles.bodyBaseBold.copyWith(
                  color: AppColors.grayscale950,
                ),
              ),
            ],
          ),
          for (final child in children) ...[const SizedBox(height: 12), child],
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: value ? AppColors.green150 : const Color(0xffF9FAFA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: value ? AppColors.green1200 : const Color(0xffE6E9EA),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? AppColors.green1500 : AppColors.grayscale400,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.bodySmallBold.copyWith(
                    color: AppColors.grayscale950,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppStyles.bodyXSmallRegular.copyWith(
                    color: AppColors.grayscale400,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.green1500,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
