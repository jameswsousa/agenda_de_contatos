import 'dart:async';
import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }
            _formKey.currentState.save();
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        width: 250.0,
                        height: 250.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.teal[700], width: 2),
                          image: DecorationImage(
                              image: _editedContact.img != null
                                  ? FileImage(File(_editedContact.img))
                                  : AssetImage("images/person.png"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Container(
                          height: _editedContact.img != null ? 100 : 50,
                          width: _editedContact.img != null ? 100 : 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            color: Colors.black38,
                          ),
                          alignment: Alignment.center,
                          child: Center(
                            child: Icon(
                              _editedContact.img == null
                                  ? Icons.add_a_photo
                                  : Icons.edit,
                              color: Colors.white,
                              size: 50,
                            ),
                          ))
                    ],
                  ),
                  onTap: () {
                    ImagePicker.pickImage(
                            source: ImageSource.camera,
                            maxHeight: 1200,
                            maxWidth: 1200)
                        .then((file) {
                      if (file == null) return;
                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  },
                ),
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(fontSize: 20),
                  validator: (value) {
                    if (value.isEmpty || value == null) {
                      FocusScope.of(context).requestFocus(_nameFocus);
                      return "Insira o nome";
                    }
                  },
                  focusNode: _nameFocus,
                  decoration: InputDecoration(
                    labelText: "Nome",
                  ),
                  onChanged: (text) {
                    setState(() {
                      _userEdited = true;
                      _editedContact.name = text;
                    });
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(fontSize: 20),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(
                              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                          .hasMatch(value)) {
                        return "E-mail inválido";
                      }
                    }
                  },
                  decoration: InputDecoration(labelText: "Email"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                Container(
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone",
                    ),
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.phone = text;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
