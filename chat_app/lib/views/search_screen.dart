import 'package:chat_app/controllers/firebase_auth_controller.dart';
import 'package:chat_app/controllers/search_controller.dart';
import 'package:chat_app/resources/widgets/search/header_search.dart';
import 'package:chat_app/resources/widgets/search/search_result_user_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthController>().appUser;
    return ChangeNotifierProvider<SearchController>(
        create: (_) => SearchController(user!.uid!),
        builder: (context, child) {
          final controller = context.watch<SearchController>();
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  const HeaderSearch(),
                  Expanded(
                    child: controller.listSearchUser.isNotEmpty
                        ? ListView.builder(
                      itemCount: controller.listSearchUser.length,
                      itemBuilder: (context, index) =>
                          SearchResultUserItem(
                              appUser: controller.listSearchUser[index]),
                    )
                        : ListView.builder(
                      itemCount: controller.listAllUser.length,
                      itemBuilder: (context, index) =>
                          SearchResultUserItem(
                              appUser: controller.listAllUser[index]),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}