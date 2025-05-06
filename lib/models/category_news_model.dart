import 'package:anewsment/models/cluster_model.dart';

class CategoryNewsModel {
  final String category;
  final int timestamp;
  final int read;
  final List<ClusterModel> clusters;

  CategoryNewsModel({
    required this.category,
    required this.timestamp,
    required this.read,
    required this.clusters,
  });

  factory CategoryNewsModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> clustersJson = json['clusters'] as List<dynamic>? ?? [];
    List<ClusterModel> clustersList =
        clustersJson
            .map((clusterJson) => ClusterModel.fromJson(clusterJson))
            .toList();

    return CategoryNewsModel(
      category: json['category'] as String? ?? '',
      timestamp: json['timestamp'] as int? ?? 0,
      read: json['read'] as int? ?? 0,
      clusters: clustersList,
    );
  }
}
