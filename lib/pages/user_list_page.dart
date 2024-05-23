import 'package:ecom_basic_admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/helper_functions.dart';

class UserListPage extends StatelessWidget {
  static const String routeName = '/users';

  const UserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.userList.length,
          itemBuilder: (context, index) {
            final user = provider.userList[index];
            return ListTile(
              title: Text(user.displayName ?? user.email),
              subtitle: Text(
                'Subscribed on ${getFormattedDate(
                  user.userCreationTime!.toDate(),
                  pattern: 'EEE MMM dd, yyyy at hh:mm:ss a'
                )}',
              ),
            );
          },
        ),
      ),
    );
  }
}
