import 'dart:async';
import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  // static MultiStreamController<ChatUser?>? _controller;
  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);
      controller.add(_currentUser);
    }
  });

  @override
  ChatUser? get currentUser => _currentUser;

  @override
  Stream<ChatUser?> get userChanges => _userStream;

  @override
  Future<void> signIn(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUp(
      String name, String email, String password, File? image) async {
    final signUp = await Firebase.initializeApp(
      name: 'userSignup',
      options: Firebase.app().options,
    );

    final auth = FirebaseAuth.instanceFor(app: signUp);
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (credential.user == null) return;

    // 1. Upload da foto do usuário
    final String imageName = '${credential.user!.uid}.jpg';
    final String? photoURL = await _uploadUserImage(image, imageName);

    // 2. Atualizar atributos do usuário
    await credential.user?.updateDisplayName(name);
    await credential.user?.updatePhotoURL(photoURL);

    // 2.5 Fazer o login do usuário
    await signIn(email, password);

    // 3. Salvar o usuário no banco de dados (opcional)
    await _saveChatUser(_toChatUser(credential.user!, name, photoURL));

    await signUp.delete();
  }

  @override
  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {});
    return await imageRef.getDownloadURL();
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);
    return docRef.set(
        {'name': user.name, 'email': user.email, 'photoUrl': user.photoUrl});
  }

  static ChatUser _toChatUser(User user, [String? name, String? photoUrl]) =>
      ChatUser(
          id: user.uid,
          name: name ?? user.displayName ?? user.email!.split('@').first,
          email: user.email!,
          photoUrl: photoUrl ?? user.photoURL ?? 'assets/images/avatar.png');
}
