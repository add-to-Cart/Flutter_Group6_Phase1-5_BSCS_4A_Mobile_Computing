import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
        backgroundColor: Colors.amber,
        elevation: 8,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('leaderboard')
            .orderBy('score', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading leaderboard"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No leaderboard data found"));
          }

          final leaderboardData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: leaderboardData.length,
            itemBuilder: (context, index) {
              final data =
                  leaderboardData[index].data() as Map<String, dynamic>;
              final playerName = data['playerName'] ?? 'Unknown';
              final score = data['score'] ?? 0;
              final category = data['category'] ?? 'N/A';
              final result = data['result'] ?? 'Unknown';
              final date = (data['date'] as Timestamp).toDate();

              return ListTile(
                leading: CircleAvatar(
                  child: Text("#${index + 1}"),
                ),
                title: Text(playerName),
                subtitle: Text("Category: $category | Result: $result"),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Score: $score",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Date: ${date.toLocal()}"),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
