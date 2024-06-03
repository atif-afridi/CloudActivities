import 'package:cloud_bucket/models/intent_model.dart';
import 'package:cloud_bucket/viewmodels/intent_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewIntentsScreen extends StatelessWidget {
  final IntentModelProvider _viewModel = IntentModelProvider();

  ViewIntentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Activities')),
      body: FutureBuilder<List<IntentModel>>(
        // two variants are used here
        // future: _viewModel.fetchActivities(),
        future: _viewModel.fetchActivitiesRepo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No activities found'));
          } else {
            List<IntentModel> activities = snapshot.data!;
            return ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                IntentModel activity = activities[index];
                return ListTile(
                  title: Text(activity.text),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (activity.imageUrls.isNotEmpty)
                        Text('Images: ${activity.imageUrls.length}'),
                      if (activity.pdfUrls.isNotEmpty)
                        Text('PDFs: ${activity.pdfUrls.length}'),
                      Text(
                          'Uploaded: ${DateFormat('yyyy-MM-dd – kk:mm:a').format(activity.timestamp!)}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
