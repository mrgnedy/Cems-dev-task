import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:githubapi/src/data/repo_model.dart';
import 'package:githubapi/src/presentation/state/github_repo_cubit.dart';
import 'package:githubapi/src/utils/base_state.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:supercharged/supercharged.dart';

class GithubRepoList extends StatefulWidget {
  const GithubRepoList({super.key});

  @override
  State<GithubRepoList> createState() => _GithubRepoListState();
}

class _GithubRepoListState extends State<GithubRepoList> {
  @override
  void initState() {
    super.initState();
    cubit.getGithubRepos();
    Timer.periodic(1.hours, (timer) {
      cubit.getGithubRepos(force: true, page: 1);
      showSimpleNotification(Text("Data Updated"), background: Colors.green.withOpacity(0.8));
    });
  }

  final cubit = GithubRepoCubit();
  final scrollCtrler = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "GitHub Repo List",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: BlocConsumer<GithubRepoCubit, GithubReposModel>(
        bloc: cubit,
        listener: (context, state) {
          if (state.state is ErrorResult) {
            showSimpleNotification(
              Text("Error Fetching data: ${state.state.getErrorMessage()}"),
              background: Colors.red.withOpacity(
                0.8,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            child: NotificationListener(
              onNotification: (d) {
                if (d is ScrollEndNotification) {
                  cubit.getGithubRepos();
                }
                return false;
              },
              child: ListView.builder(
                controller: scrollCtrler,
                itemCount: state.repoList.length,
                itemBuilder: (context, index) {
                  final repo = state.repoList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4),
                    child: ListTile(
                      title: Text(repo.name),
                      subtitle: Text(repo.description),
                      trailing: Text(repo.owner.login),
                      onTap: () => cubit.launchRepo(repo.html_url),
                      tileColor: repo.fork ? Colors.white : Colors.lightGreen,
                    ),
                  );
                },
              ),
            ),
            onRefresh: () {
              return cubit.getGithubRepos(force: true, page: 1);
            },
          );
        },
      ),
    );
  }
}
