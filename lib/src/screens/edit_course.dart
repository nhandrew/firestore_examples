import 'package:flutter/material.dart';
import 'package:flutter_queries/src/models/course.dart';
import 'package:flutter_queries/src/services/firestore_service.dart';
import 'package:uuid/uuid.dart';

class EditCourse extends StatefulWidget {
  final String courseId;

  EditCourse({this.courseId});

  @override
  _EditCourseState createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  final _formKey = GlobalKey<FormState>();
  String _courseName;
  String _courseInstructor;
  int _courseCapacity;
  final _courseNameController = TextEditingController();
  final _courseInstructorController = TextEditingController();
  final _courseCapacityController = TextEditingController();
  final firestoreService = FirestoreService();
  var uuid = Uuid();
  Course course = null;

  @override
  void initState() {

    if (widget.courseId == null) {
      _courseNameController.text = null;
      _courseInstructorController.text = null;
      _courseCapacityController.text = null;
    } else {
      firestoreService.getOneFuture(widget.courseId).then((course){
        _courseNameController.text = course.name;
        _courseInstructorController.text = course.instructor;
        _courseCapacityController.text = course.capacity.toString();
        _courseName = course.name;
        _courseInstructor = course.name;
        _courseCapacity = course.capacity;
      });

    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _courseNameController,
                decoration: InputDecoration(labelText: 'Course Name'),
                onChanged: (value) {
                  setState(() {
                    _courseName = value;
                  });
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 6) {
                    return 'Please enter course name with 6 or more characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: _courseInstructorController,
                decoration: InputDecoration(labelText: 'Course Instructor'),
                onChanged: (value) {
                  setState(() {
                    _courseInstructor = value;
                  });
                },
                validator: (value) {
                  if (value.isEmpty || value.length < 6) {
                    return 'Please enter course name with 6 or more characters';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _courseCapacityController,
                decoration: InputDecoration(labelText: 'Course Capacity'),
                onChanged: (value) {
                  setState(() {
                    _courseCapacity = int.parse(value);
                  });
                },
                validator: (value) {
                  try {
                    int.parse(value);
                  } catch (error) {
                    return 'Please enter a valid number';
                  }

                  return null;
                },
              ),
              SizedBox(
                height: 50.0,
              ),
              if (course != null)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //Update Existing Record
                      var updatedCourse = Course(
                          capacity: _courseCapacity,
                          name: _courseName,
                          instructor: _courseInstructor,
                          courseId: course.courseId);

                      firestoreService.updateCourse(updatedCourse);
                      Navigator.of(context).pop();
                    }

                  },
                  child: Text('Update Course'),
                ),
              if (course == null)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //Add new record using add method
                      var newCourseAdd = Course(
                        capacity: _courseCapacity,
                        name: _courseName,
                        instructor: _courseInstructor,
                      );

                      firestoreService.addCourse(newCourseAdd);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Add Course with Add Method'),
                ),
              if (course == null)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      //Add new record using set method
                      var newCourseSet = Course(
                          capacity: _courseCapacity,
                          name: _courseName,
                          instructor: _courseInstructor,
                          courseId: uuid.v4());

                      firestoreService.setCourse(newCourseSet);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Add Course with Set Method'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
