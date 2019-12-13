import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

class EditProduct extends StatefulWidget {
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editProduct =
      product(id: null, title: '', price: 0, content: '', imageUrl: '');

  @override
  void initState() {
    _imageFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  var _isInit = true;
  var _isLoading=false;
  var _initValues = {
    'title': '',
    'content': '',
    'price': '',
    'imageUrl': '',
  };
  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editProduct = Provider.of<ProductProvider>(context, listen: false)
            .findById(productId);

        _initValues = {
          'title': _editProduct.title,
          'content': _editProduct.content,
          'price': _editProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _imageFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageFocusNode.dispose();
  }

  void _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final _valid = _form.currentState.validate();
    if (!_valid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading=true;
    });
    if (_editProduct.id != null) {
      Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
      setState(() {
        _isLoading=false;
      });
      Navigator.of(context).pop();
    } else {
      Provider.of<ProductProvider>(context, listen: false)
          .addProduct(_editProduct)
          .catchError((error) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(child: Text('Okay'), onPressed: () {
                Navigator.of(ctx).pop();
              },)
            ],
          ),
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _saveForm();
              })
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator()):Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editProduct = product(
                      title: value,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl,
                      content: _editProduct.content,
                      id: _editProduct.id,
                      isFavorite: _editProduct.isFavorite);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'price',
                ),
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _editProduct = product(
                      title: _editProduct.title,
                      price: double.parse(value),
                      imageUrl: _editProduct.imageUrl,
                      content: _editProduct.content,
                      id: _editProduct.id,
                      isFavorite: _editProduct.isFavorite);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'please enter a number greater than zero ';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['content'],
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                focusNode: _descriptionFocusNode,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (value) {
                  _editProduct = product(
                      title: _editProduct.title,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl,
                      content: value,
                      id: _editProduct.id,
                      isFavorite: _editProduct.isFavorite);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'please enter a description';
                  }
                  if (value.length < 10) {
                    return 'should be at  least 10 characters long.';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            )),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editProduct = product(
                            title: _editProduct.title,
                            price: _editProduct.price,
                            imageUrl: value,
                            content: _editProduct.content,
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'please enter an image url';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'please enter a valid url';
                        }
                        if (!value.endsWith('.jpeg') &&
                            !value.endsWith('.png') &&
                            !value.endsWith('.jpg')) {
                          return 'please enter a valid image url';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
