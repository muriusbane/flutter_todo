import 'package:flutter/material.dart';
import 'package:flutter_todo/todo.service.dart';
import 'package:flutter_todo/todo.model.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Todo List App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TodoService todoService = TodoService();
  final todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _futureBuilder(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  Widget _futureBuilder() {
    return FutureBuilder(
      future: todoService.getAll(),
      builder: (BuildContext context, AsyncSnapshot<List<TodoModel>> snapshot) {
        if (snapshot.hasData) {
          return _todoBuilder(todos: snapshot.data);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () => {
        todoController.clear(),
        _showAddTodoDialog(),
      },
      tooltip: 'Add Todo',
      child: Icon(Icons.add),
    );
  }

  Widget _todoBuilder({List<TodoModel> todos}) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        return _todoContent(todos, index);
      },
    );
  }

  Widget _todoContent(List<TodoModel> todos, int index) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(todos[index].body),
          Row(
            children: _actionButtons(todos, index),
          ),
        ],
      ),
    );
  }

  _actionButtons(List<TodoModel> todos, int index) {
    return <Widget>[
      _buttonBuilder(
          icon: Icons.edit,
          color: Colors.deepPurple,
          onTap: () =>
              {todoController.clear(), _showEditTodoDialog(todos[index])}),
      _buttonBuilder(
        icon: Icons.delete,
        color: Colors.deepOrange,
        onTap: () => {
          setState(() {
            todoService
                .delete(todos[index])
                .then((String message) => _toastBuilder(message));
          }),
        },
      )
    ];
  }

  Widget _buttonBuilder({IconData icon, Color color, void Function() onTap}) {
    return GestureDetector(
      child: Icon(
        icon,
        color: color,
      ),
      onTap: onTap,
    );
  }

  Future<void> _showAddTodoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Todo'),
          content: _dialogContent(),
          actions: <Widget>[
            _cancelButton(),
            _submitButtonBuilder(() => {
                  setState(() {
                    todoService
                        .post(TodoModel(
                          body: todoController.text,
                        ))
                        .then((String message) => _toastBuilder(message));
                  }),
                  Navigator.of(context).pop(),
                }),
          ],
        );
      },
    );
  }

  Future<void> _showEditTodoDialog(TodoModel todo) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${todo.body}?'),
          content: _dialogContent(),
          actions: <Widget>[
            _cancelButton(),
            _submitButtonBuilder(
              () => {
                setState(() {
                  todoService
                      .patch(TodoModel(
                        id: todo.id,
                        body: todoController.text,
                      ))
                      .then((String message) => _toastBuilder(message));
                }),
                Navigator.of(context).pop(),
              },
            ),
          ],
        );
      },
    );
  }

  Widget _dialogContent() {
    return SingleChildScrollView(
      child: TextField(
        controller: todoController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Add Todo here',
        ),
      ),
    );
  }

  Widget _submitButtonBuilder(void Function() onPressed) {
    return FlatButton(
      child: Text('Send'),
      onPressed: onPressed,
    );
  }

  Widget _cancelButton() {
    return FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Future<bool> _toastBuilder(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.deepPurple,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}
