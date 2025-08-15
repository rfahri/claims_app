import 'package:flutter/material.dart';
import '../../data/models/claim_model.dart';

class ClaimDetailPage extends StatelessWidget {
  final ClaimModel claim;

  const ClaimDetailPage({Key? key, required this.claim}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Claim Detail")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              claim.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              claim.body,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Text("Claim ID: ${claim.id}"),
            Text("User ID: ${claim.userId}"),
          ],
        ),
      ),
    );
  }
}
