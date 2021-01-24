import 'package:finalapp/actions/index.dart';
import 'package:finalapp/data/yts_api.dart';
import 'package:finalapp/epics/app_epics.dart';
import 'package:finalapp/models/index.dart';
import 'package:finalapp/presentation/home_page.dart';
import 'package:finalapp/reducer/reducer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

void main() {
  final Client client = Client();
  final YtsApi api = YtsApi(client: client);
  final AppEpics appEpics = AppEpics(ytsApi: api);
  final AppState initialState = AppState();
  final Store<AppState> store = Store<AppState>(
    reducer,
    initialState: initialState,
    middleware: <Middleware<AppState>>[
      EpicMiddleware<AppState>(appEpics.epics),
    ],
  );

  store.dispatch(GetMovies.start(initialState.page));
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, @required this.store}) : super(key: key);

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
