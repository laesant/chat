import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Carregando...',
              style: Theme.of(context).primaryTextTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(2.5),
                  minHeight: 5,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ))
          ],
        ),
      ),
    );
  }
}
