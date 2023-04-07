import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:githubapi/src/data/repo_model.dart';
import 'package:githubapi/src/utils/network_client.dart';

class GithubRepoRepo {
  final client = NetworkClient();
  Future<GithubReposModel> getRepos(int pageNumber, int perPage) async {
    try {
      final url =
          "https://api.github.com/users/square/repos?page=$pageNumber&per_page=$perPage?access_token=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";
      final Response<String> requset = await client.dio.get(url);
      final bool hasNext =
          "${requset.headers['link']}".contains("rel=\"next\"");
      final List decodedData = json.decode(requset.data!);

      return GithubReposModel.fromMap(decodedData.cast<Map<String, dynamic>>())
          .copyWith(nextPage: pageNumber + (hasNext ? 1 : 0), hasNext: hasNext);
    } catch (e) {
      rethrow;
    }
  }
}
