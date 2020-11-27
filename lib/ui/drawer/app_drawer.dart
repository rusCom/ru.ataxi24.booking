import 'package:booking/models/profile.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _createHeader(),
                    _drawerItem(context, Icons.history, "История", route: "/history"),
                    _drawerItem(context, Icons.alt_route, "Мои адреса", route: "/history"),
                    _drawerItem(context, Icons.drive_eta, "Стать водителем"),
                    _drawerItem(context, Icons.corporate_fare, "Для бизнеса"),

                    const Expanded(child: SizedBox()),
                    const Divider(height: 1.0, color: Colors.grey),
                    _drawerItem(context, Icons.info_outlined, "О программе"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, {String subtitle, String route}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
      onTap: () {
        if (route != null) {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  Widget _createDrawerItem({IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createHeader() {
    return SizedBox(
      height: 225,
      child: DrawerHeader(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/drawer_header_background.png'),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/splash_logo.png"),
                backgroundColor: Colors.white,
              ),
            ),
            Text(
              Profile().maskedPhone,
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
