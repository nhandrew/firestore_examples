import 'package:flutter/material.dart';
import 'package:flutter_queries/src/models/course.dart';
import 'package:flutter_queries/src/screens/edit_course.dart';
import 'package:flutter_queries/src/services/firestore_service.dart';

class Home extends StatelessWidget {
  final firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: StreamBuilder<List<Course>>(
          stream: firestoreService.getAllStream(),
          builder: (context, snapshot) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  if (!snapshot.hasData) return Container();

                  return Column(
                    children: [
                      if (index == 0)
                        ListTile(

                            title: Text('Course/Instructor'),
                            trailing: Text(
                              'Capacity',
                            )),
                      ListTile(
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].instructor),
                        trailing:
                            Text(snapshot.data[index].capacity.toString()),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditCourse(courseId: snapshot.data[index].courseId,))),
                      ),
                      Divider()
                    ],
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => EditCourse())),
      ),
    );
  }
}
