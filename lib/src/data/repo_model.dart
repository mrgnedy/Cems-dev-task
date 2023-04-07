import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:githubapi/src/utils/base_state.dart';

class GithubReposModel {
  final List<GithubRepoData> repoList;
  final Result state;
  final bool hasNext;
  final int nextPage;
  factory GithubReposModel.fromMap(List<Map<String, dynamic>> map) {
    return GithubReposModel(
        repoList: map.map((e) => GithubRepoData.fromMap(e)).toList());
  }

  const GithubReposModel({
    this.repoList = const [],

    this.nextPage=1,
    this.hasNext = false,
    this.state = const Result.init(),
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GithubReposModel &&
      listEquals(other.repoList, repoList) &&
      other.state == state &&
      other.hasNext == hasNext &&
      other.nextPage == nextPage;
  }

  @override
  int get hashCode {
    return repoList.hashCode ^
      state.hashCode ^
      hasNext.hashCode ^
      nextPage.hashCode;
  }

  @override
  String toString() {
    return 'GithubReposModel(repoList: $repoList, state: $state, hasNext: $hasNext, nextPage: $nextPage)';
  }

  GithubReposModel copyWith({
    List<GithubRepoData>? repoList,
    Result? state,
    bool? hasNext,
    int? nextPage,
  }) {
    return GithubReposModel(
      repoList: repoList ?? this.repoList,
      state: state ?? this.state,
      hasNext: hasNext ?? this.hasNext,
      nextPage: nextPage ?? this.nextPage,
    );
  }
}

class GithubRepoData {
  final String name;
  final Owner owner;
  final bool fork;
  final String html_url;
  final String description;
  GithubRepoData({
    required this.name,
    required this.owner,
    required this.fork,
    required this.html_url,
    required this.description,
  });

  GithubRepoData copyWith({
    String? name,
    Owner? owner,
    bool? fork,
    String? html_url,
    String? description,
  }) {
    return GithubRepoData(
      name: name ?? this.name,
      owner: owner ?? this.owner,
      fork: fork ?? this.fork,
      html_url: html_url ?? this.html_url,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'owner': owner.toMap(),
      'fork': fork,
      'html_url': html_url,
      'description': description,
    };
  }

  factory GithubRepoData.fromMap(Map<String, dynamic> map) {
    return GithubRepoData(
      name: map['name'] ?? '',
      owner: Owner.fromMap(map['owner']),
      fork: map['fork'] ?? false,
      html_url: map['html_url'] ?? '',
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GithubRepoData.fromJson(String source) =>
      GithubRepoData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GithubRepoData(name: $name, owner: $owner, fork: $fork, html_url: $html_url, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is GithubRepoData &&
      other.name == name &&
      other.owner == owner &&
      other.fork == fork &&
      other.html_url == html_url &&
      other.description == description;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      owner.hashCode ^
      fork.hashCode ^
      html_url.hashCode ^
      description.hashCode;
  }
}

class Owner {
  final String login;
  Owner({
    required this.login,
  });

  Owner copyWith({
    String? login,
  }) {
    return Owner(
      login: login ?? this.login,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'login': login,
    };
  }

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      login: map['login'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Owner.fromJson(String source) => Owner.fromMap(json.decode(source));

  @override
  String toString() => 'Owner(login: $login)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Owner && other.login == login;
  }

  @override
  int get hashCode => login.hashCode;
}
