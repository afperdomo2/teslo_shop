import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_validator/form_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_app/core/utils/validation_extensions.dart';
import 'package:teslo_app/domain/entities/product.dart';
import 'package:teslo_app/presentation/providers/product_form_provider.dart';
import 'package:teslo_app/presentation/providers/product_provider.dart';
import 'package:teslo_app/presentation/providers/products_provider.dart';

class CreateUpdateProductScreen extends ConsumerStatefulWidget {
  static const String routeName = 'create_update_product';
  final String? productId;

  const CreateUpdateProductScreen({super.key, this.productId});

  @override
  ConsumerState<CreateUpdateProductScreen> createState() => _CreateUpdateProductScreenState();
}

class _CreateUpdateProductScreenState extends ConsumerState<CreateUpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Validadores
  late final titleValidator = ValidationBuilder().required().minLength(3).build();
  late final slugValidator = ValidationBuilder().required().isSlug().build();
  late final priceValidator = ValidationBuilder().required().integer().positive().build();
  late final stockValidator = ValidationBuilder().required().integer().min(0).build();
  late final descriptionValidator = ValidationBuilder().required().minLength(10).build();

  // Controladores de texto
  late final TextEditingController _titleController;
  late final TextEditingController _slugController;
  late final TextEditingController _priceController;
  late final TextEditingController _stockController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagController;

  // Estado del formulario
  String? _selectedGender;
  final List<String> _selectedSizes = [];
  final List<String> _tags = [];
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  final List<String> _availableSizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _genderOptions = ['men', 'women', 'kid', 'unisex'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _slugController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();
    _descriptionController = TextEditingController();
    _tagController = TextEditingController();

    // Si estamos editando, cargar los datos después del primer frame
    if (widget.productId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadProductData();
      });
    }
  }

  void _loadProductData() {
    final productState = ref.read(productProvider(widget.productId!));

    if (productState.product != null) {
      final product = productState.product!;
      setState(() {
        _titleController.text = product.title;
        _slugController.text = product.slug;
        _priceController.text = product.price.toString();
        _stockController.text = product.stock.toString();
        _descriptionController.text = product.description;
        _selectedGender = product.gender;
        _selectedSizes.clear();
        _selectedSizes.addAll(product.sizes);
        _tags.clear();
        _tags.addAll(product.tags);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _slugController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _generateSlug() {
    final title = _titleController.text.trim();
    if (title.isNotEmpty) {
      final slug = title
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
          .replaceAll(RegExp(r'\s+'), '-')
          .replaceAll(RegExp(r'-+'), '-');
      _slugController.text = slug;
    }
  }

  void _addTag(String tag) {
    if (tag.trim().isNotEmpty && !_tags.contains(tag.trim())) {
      setState(() {
        _tags.add(tag.trim());
        _tagController.clear(); // Limpiar el campo después de agregar la etiqueta
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _toggleSize(String size) {
    setState(() {
      if (_selectedSizes.contains(size)) {
        _selectedSizes.remove(size);
      } else {
        _selectedSizes.add(size);
      }
    });
  }

  Future<void> _saveProduct() async {
    // Activar validación automática si no estaba activada
    if (_autovalidateMode != AutovalidateMode.always) {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGender == null) {
      _showErrorDialog('Por favor selecciona un género');
      return;
    }

    if (_selectedSizes.isEmpty) {
      _showErrorDialog('Por favor selecciona al menos una talla');
      return;
    }

    final isEditing = widget.productId != null;
    final formNotifier = ref.read(productFormProvider.notifier);

    // Crear el objeto Product
    final createUpdateProduct = Product(
      id: widget.productId ?? '',
      title: _titleController.text.trim(),
      slug: _slugController.text.trim(),
      price: int.parse(_priceController.text.trim()),
      stock: int.parse(_stockController.text.trim()),
      description: _descriptionController.text.trim(),
      gender: _selectedGender!,
      sizes: _selectedSizes,
      tags: _tags,
      images: isEditing ? ref.read(productProvider(widget.productId!)).product!.images : [],
      user: ProductUser(id: '', email: '', fullName: '', isActive: true, roles: []),
    );

    // Llamar a la función correspondiente
    final success = isEditing
        ? await formNotifier.updateProduct(createUpdateProduct)
        : await formNotifier.createProduct(createUpdateProduct);

    if (mounted) {
      if (success) {
        // Refrescar la lista de productos
        ref.read(productsProvider.notifier).refresh();

        // Si estamos editando, también refrescar el producto individual
        if (isEditing) {
          ref.invalidate(productProvider(widget.productId!));
        }

        // Mostrar mensaje de éxito y navegar atrás
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Producto actualizado exitosamente' : 'Producto creado exitosamente',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );

        // Esperar un momento antes de navegar para que el usuario vea el mensaje
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.pop(); // Volver a la pantalla anterior
        }
      } else {
        // Mostrar error
        final errorMessage = ref.read(productFormProvider).errorMessage;
        _showErrorDialog(errorMessage ?? 'Error al guardar el producto');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productId != null;
    final productState = isEditing ? ref.watch(productProvider(widget.productId!)) : null;
    final formState = ref.watch(productFormProvider);

    if (isEditing && productState != null && productState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Producto' : 'Nuevo Producto'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                  helperText: 'Mínimo 3 caracteres',
                ),
                validator: titleValidator,
                onChanged: (_) => _generateSlug(),
              ),
              const SizedBox(height: 16),

              // Slug
              TextFormField(
                controller: _slugController,
                decoration: InputDecoration(
                  labelText: 'Slug *',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.link),
                  helperText: 'Solo letras minúsculas, números y guiones',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _generateSlug,
                    tooltip: 'Generar slug',
                  ),
                ),
                validator: slugValidator,
              ),
              const SizedBox(height: 16),

              // Precio y Stock
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Precio *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                        helperText: 'Mayor a 0',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: priceValidator,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(
                        labelText: 'Stock *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.inventory_2),
                        helperText: 'Desde 0',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: stockValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Descripción
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                  helperText: 'Mínimo 10 caracteres',
                ),
                maxLines: 4,
                validator: descriptionValidator,
              ),
              const SizedBox(height: 24),

              // Género
              Text(
                'Género *',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _genderOptions.map((gender) {
                  final isSelected = _selectedGender == gender;
                  return ChoiceChip(
                    label: Text(
                      gender == 'men'
                          ? 'Hombre'
                          : gender == 'women'
                          ? 'Mujer'
                          : gender == 'kid'
                          ? 'Niño'
                          : 'Unisex',
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedGender = selected ? gender : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Tallas
              Text(
                'Tallas *',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _availableSizes.map((size) {
                  final isSelected = _selectedSizes.contains(size);
                  return FilterChip(
                    label: Text(size),
                    selected: isSelected,
                    onSelected: (_) => _toggleSize(size),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Tags
              Text(
                'Etiquetas',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _tagController,
                      decoration: const InputDecoration(
                        labelText: 'Agregar etiqueta',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.local_offer),
                      ),
                      onFieldSubmitted: (value) {
                        _addTag(value);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () => _removeTag(tag),
                      deleteIcon: const Icon(Icons.close, size: 18),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 32),

              // Botón de guardar
              ElevatedButton(
                onPressed: formState.isLoading ? null : _saveProduct,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: formState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        isEditing ? 'Actualizar Producto' : 'Crear Producto',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
