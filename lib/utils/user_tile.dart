import 'package:auth_database_cart/models/our_user.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final OurUser? user;

  const UserTile({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Text(user!.name),
          subtitle: Text(user!.profession),
          trailing: Text(user!.contactNumber),
        ),
      ),
    );
  }
}
