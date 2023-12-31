import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;
  const AuthForm({super.key, required this.onSubmit});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _formData = AuthFormData();

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _submit() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (_formData.isSignup && _formData.image == null) {
      _showError('Selecione uma imagem');
      return;
    }
    widget.onSubmit(_formData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                if (_formData.isSignup)
                  Column(
                    children: [
                      UserImagePicker(onImagePick: _handleImagePick),
                      TextFormField(
                        key: const ValueKey('name'),
                        initialValue: _formData.name,
                        onChanged: (name) => _formData.name = name,
                        decoration: const InputDecoration(labelText: "Nome"),
                        validator: (value) {
                          final name = value ?? "";
                          if (name.trim().length < 5) {
                            return 'Nome deve ter no mínimo 5 caracteres.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                TextFormField(
                  key: const ValueKey('email'),
                  initialValue: _formData.email,
                  onChanged: (email) => _formData.email = email,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) {
                    final email = value ?? "";
                    if (!email.contains('@')) {
                      return 'E-mail informado não é válido.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  obscureText: true,
                  initialValue: _formData.password,
                  onChanged: (password) => _formData.password = password,
                  decoration: const InputDecoration(labelText: "Senha"),
                  validator: (value) {
                    final password = value ?? "";
                    if (password.length < 6) {
                      return 'Senha deve ter no mínimo 6 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                    onPressed: _submit,
                    child: Text(_formData.isLogin ? 'Entrar' : "Cadastrar")),
                const SizedBox(height: 12),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _formData.toggleAuthMode();
                      });
                    },
                    child: Text(_formData.isLogin
                        ? "Criar uma nova conta?"
                        : "Já possui conta?"))
              ],
            )),
      ),
    );
  }
}
