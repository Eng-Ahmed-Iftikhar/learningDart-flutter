import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/enums/menu_action.dart';
import 'package:learningdart/services/auth/auth_service.dart';
import 'package:learningdart/services/auth/auth_user.dart';
import 'package:learningdart/services/datebase/database_service.dart';
import 'package:learningdart/services/note/database_note.dart';
import 'package:learningdart/services/note/notes_service.dart';
import 'package:learningdart/services/user/user_service.dart';
import 'package:learningdart/utilties/show_logout_dialog.dart';
import 'package:learningdart/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final DatabaseService _databaseService;

  AuthUser get user => AuthService.firebase().currentUser!;

  @override
  void initState() {
    _databaseService = DatabaseService();
    _databaseService.open();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        elevation: 3,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight(600),
        ),
        backgroundColor: Colors.blue.shade500,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: Icon(Icons.add, color: Colors.white),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    await AuthService.firebase().logout();
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(child: Text(user.email ?? "")),
                PopupMenuDivider(),
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
              ];
            },
            iconColor: Colors.white,
          ),
        ],
      ),
      body: FutureBuilder(
        future: UserService.database().getOrCreateUser(email: user.email!),
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: NotesService.database().allNotes,
                builder: (context, snapshot) {
                  print(snapshot.data);
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;

                        return NotesListView(
                          notes: allNotes,
                          onDeleteNote: (note) async {
                            await NotesService.database().deleteNote(
                              id: note.id,
                            );
                          },
                          onTapNote: (note) {
                            Navigator.of(context).pushNamed(
                              createOrUpdateNoteRoute,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }

                    default:
                      return CircularProgressIndicator();
                  }
                },
              );
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
