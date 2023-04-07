import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:githubapi/src/data/githubapi_repo.dart';
import 'package:githubapi/src/data/repo_model.dart';
import 'package:githubapi/src/utils/base_state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GithubRepoCubit extends Cubit<GithubReposModel> {
  GithubRepoCubit() : super(const GithubReposModel());
  final repo = GithubRepoRepo();
  getGithubRepos({bool force = false, int? page}) async {
    try {
      final lastRepos = state.repoList;
      final data = await repo.getRepos(page ?? state.nextPage, 10);
      emit(data.copyWith(repoList: [...lastRepos, ...data.repoList]));
    } catch (e) {
      String err = '$e';
      if (e is DioError) err = e.message ?? '';

      emit(state.copyWith(state: Result.error(err)));
    }
  }

  launchRepo(String url) async {
    print(url);
    try {
      await launchUrlString(Uri.encodeFull(url));
    } catch (e) {
      print("Cant launch: $e");
    }
  }
}
